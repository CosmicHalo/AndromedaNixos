{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.alacritty;
  yamlFormat = pkgs.formats.yaml {};
  isWayland = config.wayland.windowManager.hyprland.enable;

  defaultSettings = {
    cursor.style = "Beam";
    live_config_reload = true;
    env.TERM = "xterm-256color";

    window = {
      decorations = "full";
      dynamic_padding = true;
      decorations_theme_variant = "Dark";

      padding = {
        x = 8;
        y = 8;
      };
    };

    font = let
      fontName = cfg.font.name;
      fontSize = cfg.font.size;
    in {
      normal = {
        style = "Light";
        family = fontName;
      };
      bold = {
        style = "Medium";
        family = fontName;
      };
      italic = {
        style = "Italic";
        family = fontName;
      };
      bold_italic = {
        style = "bold_italic";
        family = fontName;
      };

      # Weird, but it works...
      size =
        if isWayland
        then fontSize * 1.05
        else fontSize;
    };

    extraConfig = ''
      # all alacritty themes can be found at
      #    https://github.com/alacritty/alacritty-theme
      - ~/.config/alacritty/theme_catppuccin.yml
    '';
  };
in {
  options.milkyway.apps.alacritty = with types; {
    enable = mkEnableOption "alacritty terminal";

    package = mkOption {
      type = types.package;
      default = pkgs.alacritty;
      defaultText = literalExpression "pkgs.alacritty";
      description = "The Alacritty package to install.";
    };

    font = {
      name = mkStrOpt "Monaspace Krypton" "Font name to use";
      size = mkOpt number 10 "Font package to use";
      package = mkNullOpt package null "Font package to use";
    };

    settings =
      mkOpt yamlFormat.type defaultSettings ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/alacritty/alacritty.yml`. See
        <https://github.com/alacritty/alacritty/blob/master/alacritty.yml>
        for the default configuration.
      ''
      // {
        example = literalExpression ''
          {
            window.dimensions = {
              lines = 3;
              columns = 200;
            };
            key_bindings = [
              {
                key = "K";
                mods = "Control";
                chars = "\\x0c";
              }
            ];
          }
        '';
      };
  };

  config = mkIf cfg.enable {
    xdg.configFile."alacritty/theme_catppuccin.yml".source = "${get-source "catppuccin-alacritty"}/catppuccin-mocha.yml";

    programs.alacritty = {
      enable = true;
      inherit (cfg) package settings;
    };

    home.packages =
      optional (cfg.font.package != null)
      cfg.font.package;
  };
}
