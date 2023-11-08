{
  lib,
  pkgs,
  config,
  isLinux,
  ...
}:
with lib;
with lib.milkyway; let
  keySubmodule = with types; {
    options = {
      text =
        mkNullOpt str null
        "Text of an OpenPGP public key.";
      source =
        mkOpt path null
        "Path of an OpenPGP public key file.";

      trust =
        defaultNullOpts.mkEnum ["unknown" 1 "never" 2 "marginal" 3 "full" 4 "ultimate" 5] ''
          The amount of trust you have in the key ownership and the care the
          owner puts into signing other keys. The available levels are

          `unknown` or `1`
          : I don't know or won't say.

          `never` or `2`
          : I do **not** trust.

          `marginal` or `3`
          : I trust marginally.

          `full` or `4`
          : I trust fully.

          `ultimate` or `5`
          : I trust ultimately.

          See the [Key Management chapter](https://www.gnupg.org/gph/en/manual/x334.html)
          of the GNU Privacy Handbook for more.
        ''
        // {
          apply = v:
            if isString v
            then
              {
                unknown = 1;
                never = 2;
                marginal = 3;
                full = 4;
                ultimate = 5;
              }
              .${v}
            else v;
        };
    };
  };

  cfg = config.milkyway.security.gpg;
  cfgAgent = config.milkyway.security.gpg-agent;

  reload-yubikey = pkgs.writeShellScriptBin "reload-yubikey" ''
    ${pkgs.gnupg}/bin/gpg-connect-agent "scd serialno" "learn --force" /bye
  '';

  pinentry =
    if config.gtk.enable
    then {
      name = "gnome3";
      package = pkgs.pinentry-gnome3;
      packages = with pkgs; [
        gcr
        pinentry-qt
        pinentry-rofi
        pinentry-gnome3
      ];
    }
    else {
      name = "curses";
      package = pkgs.pinentry-curses;
      packages = with pkgs; [
        pinentry-curses
      ];
    };

  gpgAgentConf = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
    pinentry-program ${pinentry.package}/bin/pinentry-${pinentry.name}
  '';
in {
  options.milkyway.security = with types; {
    gpg = {
      enable = mkEnableOption "Whether or not to enable GPG.";
      package = mkPackageOpt pkgs.gnupg "The GPG Agent package.";

      homedir =
        mkStrOpt "${config.home.homeDirectory}/.gnupg"
        "The GPG home directory.";
      mutableTrust =
        mkBoolOpt true
        "Whether or not to enable mutable trust.";
      publicKeys =
        mkListOpt (types.submodule keySubmodule) []
        "The public keys to load.";
    };

    gpg-agent = {
      enable = mkEnableOption "Whether or not to enable GPG Agent.";

      maxCacheTtl = mkOpt (nullOr int) null "The max cache TTL.";
      defaultCacheTtl = mkOpt (nullOr int) null "The default cache TTL.";
      maxCacheTtlSsh = mkOpt (nullOr int) null "The max cache TTL for SSH.";
      defaultCacheTtlSsh = mkOpt (nullOr int) null "The default cache TTL for SSH.";

      enableSshSupport =
        mkBoolOpt true
        "Whether or not to enable SSH support.";
      enableExtraSocket =
        mkBoolOpt false
        "Whether or not to enable the extra socket.";
      enableScDaemon =
        mkBoolOpt true
        "Whether or not to enable the scdaemon.";
      sshKeys =
        mkOpt (nullOr (listOf str)) null
        "The SSH keys to load.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.gpg = cfg;

      home = {
        packages = with pkgs;
          pinentry.packages
          ++ [
            gnupg
            paperkey
            reload-yubikey
          ]
          ++ optionals isLinux [
            cryptsetup
          ];

        file = {
          ".pam-gnupg".text = mkDefault ''
            ${config.programs.gpg.homedir}
            ${config.milkyway.tools.git.signingKey or ""}
          '';
        };
      };
    }

    (mkIf cfgAgent.enable {
      services.gpg-agent =
        cfgAgent
        // {
          pinentryFlavor = pinentry.name;
        };

      programs = let
        fixGpg = ''gpgconf --launch gpg-agent'';
      in {
        # Start gpg-agent if it's not running or tunneled in
        # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
        # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
        zsh.loginExtra = fixGpg;
        bash.profileExtra = fixGpg;
      };

      home.file.".gnupg/gpg-agent.conf".text = gpgAgentConf;
    })
  ]);
}
