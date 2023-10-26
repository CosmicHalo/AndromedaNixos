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
in {
  imports = [
    ./settings.nix
  ];

  options.milkyway.nix = with types; {
    package = mkOpt package pkgs.nixUnstable "Which nix package to use.";

    optimise = {
      enable = mkBoolOpt true "Whether or not to enable automatic nix store optimiser.";
      dates = mkOpt (listOf str) ["12.00"] "Specification of the time at which the optimiser will run";
    };

    daemonCPUSchedPolicy =
      mkOpt (enum ["other" "batch" "idle"])
      "batch" "Nix daemon process CPU scheduling policy.";

    daemonIOSchedClass =
      mkOpt (enum ["best-effort" "idle"])
      "best-effort" "Nix daemon process I/O scheduling class.";

    extraNixPackages =
      mkOpt (listOf package) []
      "Extra nix packages to install.";

    default-substituter = {
      url = mkOpt str "https://cache.nixos.org" "The url for the substituter.";
      key = mkOpt str "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "The trusted public key for the substituter.";
    };

    extra-substituters = mkOpt (attrsOf substituters-submodule) {
      "https://andromeda.cachix.org".key = "andromeda.cachix.org-1:NFRC6xT8LwjhkJ9/d7z6MrbqXrBbMgOucKGxBbXyQRg=";
      "https://cache.garnix.io".key = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
      "https://viperml.cachix.org".key = "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8=";
      "https://nix-community.cachix.org".key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    } "Extra substituters to configure.";

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
  };

  config = mkMerge [
    ##########
    #Chaotic
    ##########
    (mkIf cfg.chaotic-nyx.enable {
      chaotic.nyx.cache.enable = choticCfg.cache.enable;
      chaotic.nyx.overlay.enable = choticCfg.overlay.enable;
    })

    ##########
    #  NIX
    ##########
    {
      assertions =
        mapAttrsToList
        (name: value: {
          assertion = value.key != null;
          message = "galaxy.nix.extra-substituters.${name}.key must be set";
        })
        cfg.extra-substituters;

      environment.systemPackages = with pkgs;
        [nil]
        ++ cfg.extraNixPackages;

      nix = {
        inherit (cfg) package;

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
