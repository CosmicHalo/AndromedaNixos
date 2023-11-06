{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.security.gpg;

  gpgConf = "${inputs.gpg-base-conf}/gpg.conf";

  gpgAgentConf = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
  '';
in {
  options.milkyway.security.gpg = {
    enable = mkEnableOption "GPG";
    agentTimeout = mkOpt types.int 5 "The amount of time to wait before continuing with shell init.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnupg
    ];

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

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    milkyway.home.file = {
      ".gnupg/.keep".text = "";
      ".gnupg/gpg.conf".source = gpgConf;
      ".gnupg/gpg-agent.conf".text = gpgAgentConf;
    };
  };
}
