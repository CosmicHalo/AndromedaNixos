{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.suites.development;
in {
  options.milkyway.suites.development = with types; {
    enable = mkEnableOption "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    milkyway = {
      apps = {
        # programs
        docker = enabled;

        # Editors
        neovim = enabled;

        # Terminal
        kitty = enabled;
        alacritty = enabled;

        # Shell
        tmux = enabled;
        zoxide = enabled;
        zellij = enabled;
      };

      development = {
        rust = enabled;
        nodejs = enabled;
      };

      tools = {
        rtx = enabled;
      };

      shell = {
        git = enabled;
        ssh = enabled;
        # starship = enabled;
        zsh = enabled;
      };
    };
  };
}
