{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.security.gpg;
  cfgAgent = config.milkyway.security.gpg-agent;

  gpgConf = "${get-source "gpg-base-conf"}/gpg.conf";
  gpgAgentConf = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
    pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt
  '';
in {
  options.milkyway.security = {
    gpg = {
      enable = mkEnableOption "GPG";
      agentTimeout = mkOpt types.int 5 "The amount of time to wait before continuing with shell init.";
    };

    gpg-agent = {
      enable = mkBoolOpt true "Whether or not to enable GPG Agent.";
      enableSSHSupport = mkBoolOpt true "Whether or not to enable SSH Support.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        gnupg
        pinentry-qt
        pinentry-curses
      ];

      milkyway.home.file = {
        ".gnupg/.keep".text = mkDefault "";
        ".gnupg/gpg.conf".source = mkDefault gpgConf;
      };
    }

    (mkIf cfgAgent.enable {
      programs.gnupg.agent = cfgAgent;

      milkyway.home.file = {
        ".gnupg/gpg-agent.conf".text = gpgAgentConf;
      };

      environment.shellInit = ''
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
    })
  ]);
}
