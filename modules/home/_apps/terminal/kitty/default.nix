{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.kitty;
in {
  options.milkyway.apps.kitty = with types; {
    enable = mkEnableOption "kitty terminal emulator";

    theme = mkOpt str "Catppuccin-Mocha" ''
      Theme to use for kitty.
      This option takes the friendly name of any theme given by the command kitty +kitten themes.
      See https://github.com/kovidgoyal/kitty-themes for more details
    '';

    font = {
      size = mkOpt number 10.0 "Font package to use for kitty";
      name = mkOpt str "CartographCF Nerd Font" "Font name to use for kitty";
      package = mkOpt (nullOr package) null "Font package to use for kitty";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [kitty kitty-themes];
      sessionVariables = {
        TERMINAL = "kitty -1";
      };
    };

    programs.kitty = {
      enable = true;

      inherit (cfg) theme font;

      shellIntegration = {
        enableZshIntegration = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };

      settings = {
        scrollback_lines = 4000;
        window_padding_width = 15;
        scrollback_pager_history_size = 2048;

        enable_audio_bell = "no";
        placement_strategy = "center";
        allow_remote_control = "yes";
        visual_bell_duration = "0.0";
        copy_on_select = "clipboard";
        visual_bell_color = "none";
      };
    };
  };
}
