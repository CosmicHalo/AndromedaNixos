{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.nix;
  choticCfg = cfg.chaotic-nyx;

  substituters-submodule = types.submodule (_: {
    options = with types; {
      key = mkOpt (nullOr str) null "The trusted public key for this substituter.";
    };
  });

  buildMachinesOpt = with types; (submodule {
    options = {
      hostName =
        mkStrOpt null "The hostname of the build machine."
        // {example = "nixbuilder.example.org";};
      protocol =
        mkEnumOpt ["ssh" "ssh-ng"] "ssh" ''
          The protocol used for communicating with the build machine.
          Use `ssh-ng` if your remote builder and your
          local Nix version support that improved protocol.

          Use `null` when trying to change the special localhost builder
          without a protocol which is for example used by hydra.
        ''
        // {example = "ssh-ng";};
      system =
        mkNullOpt str null ''
          The system type the build machine can execute derivations on.
          Either this attribute or {var}`systems` must be
          present, where {var}`system` takes precedence if
          both are set.
        ''
        // {example = "x86_64-linux";};
      systems =
        mkOpt (listOf str) [] ''
          The system types the build machine can execute derivations on.
          Either this attribute or {var}`system` must be
          present, where {var}`system` takes precedence if
          both are set.
        ''
        // {example = ["x86_64-linux" "aarch64-linux"];};
      sshUser =
        mkNullOpt str null ''
          The username to log in as on the remote host. This user must be
          able to log in and run nix commands non-interactively. It must
          also be privileged to build derivations, so must be included in
          {option}`nix.settings.trusted-users`.
        ''
        // {example = "builder";};
      sshKey =
        mkNullOpt str null ''
          The path to the SSH private key with which to authenticate on
          the build machine. The private key must not have a passphrase.
          If null, the building user (root on NixOS machines) must have an
          appropriate ssh configuration to log in non-interactively.

          Note that for security reasons, this path must point to a file
          in the local filesystem, *not* to the nix store.
        ''
        // {example = "/root/.ssh/id_buildhost_builduser";};
      maxJobs = mkIntOpt 1 ''
        The number of concurrent jobs the build machine supports. The
        build machine will enforce its own limits, but this allows hydra
        to schedule better since there is no work-stealing between build
        machines.
      '';
      speedFactor = mkIntOpt 1 ''
        The relative speed of this builder. This is an arbitrary integer
        that indicates the speed of this builder, relative to other
        builders. Higher is faster.
      '';
      mandatoryFeatures =
        mkOpt (listOf str) [] ''
          A list of features mandatory for this builder. The builder will
          be ignored for derivations that don't require all features in
          this list. All mandatory features are automatically included in
          {var}`supportedFeatures`.
        ''
        // {example = ["big-parallel"];};

      supportedFeatures =
        mkOpt (listOf str) [] ''
          A list of features supported by this builder. The builder will
          be ignored for derivations that require features not in this
          list.
        ''
        // {example = ["kvm" "big-parallel"];};

      publicHostKey = mkNullOpt str null ''
        The (base64-encoded) public host key of this builder. The field
        is calculated via {command}`base64 -w0 /etc/ssh/ssh_host_type_key.pub`.
        If null, SSH will use its regular known-hosts file when connecting.
      '';
    };
  });
in {
  imports = [
    ./settings.nix
  ];

  options.milkyway.nix = with types; {
    package =
      mkOpt package pkgs.nixUnstable
      "Which nix package to use.";

    daemonCPUSchedPolicy =
      mkOpt (enum ["other" "batch" "idle"])
      "batch" "Nix daemon process CPU scheduling policy.";
    daemonIOSchedClass =
      mkOpt (enum ["best-effort" "idle"])
      "best-effort" "Nix daemon process I/O scheduling class.";

    default-substituter = {
      url = mkOpt str "https://cache.nixos.org" "The url for the substituter.";
      key = mkOpt str "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "The trusted public key for the substituter.";
    };
    extra-substituters =
      mkOpt (attrsOf substituters-submodule)
      {
        "https://andromeda.cachix.org".key = "andromeda.cachix.org-1:NFRC6xT8LwjhkJ9/d7z6MrbqXrBbMgOucKGxBbXyQRg=";
        "https://cache.garnix.io".key = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
        "https://viperml.cachix.org".key = "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8=";
        "https://nix-community.cachix.org".key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      } "Extra substituters to configure.";

    optimise = {
      enable = mkBoolOpt true "Whether or not to enable automatic nix store optimiser.";
      dates = mkOpt (listOf str) ["12.00"] "Specification of the time at which the optimiser will run";
    };
    gc = {
      enable = mkBoolOpt true "Whether or not to enable garbage collection.";
      automatic = mkBoolOpt true "Whether or not to enable automatic garbage collection.";
      options = mkOpt str "--delete-older-than 3d" "The options to pass to nix-collect-garbage.";
      dates = mkOpt (enum ["daily" "weekly" "monthly"]) "daily" "The frequency of garbage collection.";
    };

    chaotic-nyx = {
      enable = mkBoolOpt true "Whether or not to enable chaotic-nyx.";
      cache = mkEnableOpt' "chaotic-nyx cache";
      overlay = mkEnableOpt' "chaotic.nyx overlay";
    };

    distributedBuilds = {
      enable = mkEnableOption "Nix distributed builds";

      buildMachines = mkOpt (listOf buildMachinesOpt) [] ''
        This option lists the machines to be used if distributed builds are
        enabled (see {option}`nix.distributedBuilds`).
        Nix will perform derivations on those machines via SSH by copying the
        inputs to the Nix store on the remote machine, starting the build,
        then copying the output back to the local Nix store.
      '';
    };

    extraNixPackages =
      mkOpt (listOf package) []
      "Extra nix packages to install.";
    extraOptions =
      mkLinesOpt ""
      "Extra options to pass to nix.";
  };

  config = mkMerge [
    ##########
    #Chaotic
    ##########
    (mkIf cfg.distributedBuilds.enable {
      nix = {
        distributedBuilds = true;

        extraOptions = ''
          builders-use-substitutes = true
        '';

        inherit (cfg.distributedBuilds) buildMachines;
      };
    })

    ##########
    #  NIX
    ##########

    (mkIf cfg.chaotic-nyx.enable {
      chaotic.nyx.cache.enable = choticCfg.cache.enable;
      chaotic.nyx.overlay.enable = choticCfg.overlay.enable;
    })

    {
      assertions =
        mapAttrsToList
        (name: value: {
          assertion = value.key != null;
          message = "milkyway.nix.extra-substituters.${name}.key must be set";
        })
        cfg.extra-substituters;

      environment.systemPackages = cfg.extraNixPackages;

      nix = {
        inherit (cfg) package extraOptions;

        optimise = mkIf cfg.optimise.enable {
          automatic = true;
          inherit (cfg.optimise) dates;
        };

        # Garbage collection
        gc = mkIf cfg.gc.enable {
          inherit (cfg.gc) dates options automatic;
        };

        # flake-utils-plus
        linkInputs = true;
        generateNixPathFromInputs = true;
        generateRegistryFromInputs = true;

        #  Make builds run with low priority so my system stays responsive
        inherit (cfg) daemonIOSchedClass;
        inherit (cfg) daemonCPUSchedPolicy;
      };
    }
  ];
}
