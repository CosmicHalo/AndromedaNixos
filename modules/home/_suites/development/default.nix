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
    enable =
      mkBoolOpt false
      "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    milkyway = {
      apps = {
        # IDES
        vscode = enabled;
        jetbrains = enabled;
      };

      shell = {
        # comma = enabled;
        # direnv = enabled;
        git = enabled;
        neovim = enabled;
        # ssh = enabled;
        # starship = enabled;
        zsh = enabled;
      };
    };

    home.packages = with pkgs; [
      bat
      curl
      devbox
      eza
      fastfetch
      fd
      fzf
      grc
      jq
      killall
      libva-utils
      nvd
      ripgrep
      tldr
      usbutils
      vulkan-tools
      wget
    ];
  };
}
