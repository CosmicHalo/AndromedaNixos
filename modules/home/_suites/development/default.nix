{
  lib,
  pkgs,
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
    home.packages = with pkgs; [
      commitizen
    ];

    milkyway = {
      programs = {
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
        go = enabled;
        rust = enabled;
        nodejs = enabled;
      };

      tools = {
        git = enabled;
        rtx = enabled;
      };

      shell = {
        ssh = enabled;
        zsh = enabled;
      };
    };
  };
}
