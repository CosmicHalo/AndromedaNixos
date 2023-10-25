{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.security.gpg;

  pinentry =
    if config.home-manager.users.${config.milkyway.user.name}.gtk.enable
    then {
      name = "gnome3";
      packages = with pkgs; [
        gcr
        pinentry-gnome
        pinentry-rofi
      ];
    }
    else {
      name = "curses";
      packages = with pkgs; [
        pinentry-curses
      ];
    };
in {
  options.milkyway.security.gpg = with types; {
    enable = mkBoolOpt false "Whether or not to enable GPG.";
    agentTimeout = mkOpt int 5 "The amount of time to wait before continuing with shell init.";

    enableScDaemon =
      mkBoolOpt true
      "Whether or not to enable the scdaemon.";
    enableExtraSocket =
      mkBoolOpt true
      "Whether or not to enable the extra socket.";
  };

  config = mkIf cfg.enable {
    programs = {
      ssh.startAgent = false;

      gnupg.agent = {
        enable = true;

        pinentryFlavor = pinentry.name;
        enableSSHSupport = cfg.enableScDaemon;
        inherit (cfg) enableExtraSocket;
      };
    };

    services = {
      pcscd.enable = true;
      udev.packages = with pkgs; [yubikey-personalization];
    };

    environment = {
      # *NOTE(lecoqjacob): This should already have been added by programs.gpg, but
      # *keeping it here for now just in case.
      shellInit = ''
        export GPG_TTY="$(tty)"
        export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)

        ${pkgs.coreutils}/bin/timeout ${builtins.toString cfg.agentTimeout} ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
        gpg_agent_timeout_status=$?

        if [ "$gpg_agent_timeout_status" = 124 ]; then
          # Command timed out...
          echo "GPG Agent timed out..."
          echo 'Run "gpgconf --launch gpg-agent" to try and launch it again.'
        fi
      '';
    };
  };
}
