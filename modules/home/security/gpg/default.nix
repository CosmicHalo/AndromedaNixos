{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types mkIf mkMerge;
  inherit (lib.milkyway) mkOpt mkBoolOpt getSource;

  cfg = config.milkyway.security.gpg;
  cfgAgent = config.milkyway.security.gpg.gpg-agent;

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

  gpgConf = "${getSource "gpg-base-conf"}/gpg.conf";
  gpgAgentConf = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
    pinentry-program ${pinentry.package}/bin/pinentry-${pinentry.name}
  '';
in {
  options.milkyway.security.gpg = with types; {
    enable = mkBoolOpt false "Whether or not to enable GPG.";
    agentTimeout = mkOpt int 5 "The amount of time to wait before continuing with shell init.";

    gpg-agent = {
      enable = mkBoolOpt false "Whether or not to enable GPG Agent.";

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
    (mkIf cfgAgent.enable {
      home.file.".gnupg/gpg-agent.conf".text = gpgAgentConf;

      programs = let
        fixGpg = ''
          gpgconf --launch gpg-agent
        '';
      in {
        # Start gpg-agent if it's not running or tunneled in
        # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
        # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
        zsh.loginExtra = fixGpg;
        bash.profileExtra = fixGpg;

        gpg = {
          enable = true;
          homedir = "${config.xdg.dataHome}/gnupg";
        };
      };

      services.gpg-agent = {
        inherit
          (cfgAgent)
          defaultCacheTtl
          defaultCacheTtlSsh
          enableExtraSocket
          enableScDaemon
          enableSshSupport
          maxCacheTtl
          maxCacheTtlSsh
          sshKeys
          ;

        enable = true;
        pinentryFlavor = pinentry.name;
      };
    })

    {
      home = {
        packages = with pkgs;
          pinentry.packages
          ++ [
            reload-yubikey

            cryptsetup
            gcr_4
            gnupg
            paperkey
            paperkey
          ];

        file = {
          ".gnupg/.keep".text = "";
          ".gnupg/gpg.conf".source = gpgConf;
          ".pam-gnupg".text = ''
            ${config.programs.gpg.homedir}
            ${config.milkyway.tools.git.signingKey or ""}
          '';
        };
      };
    }
  ]);
}
