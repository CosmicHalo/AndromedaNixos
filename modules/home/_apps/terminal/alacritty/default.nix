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
    live_config_reload = true;
    env.TERM = "xterm-256color";
    selection.save_to_clipboard = true;

    bell = {
      duration = 300;
      animation = "EaseOutExpo";
    };

    window = {
      opacity = 0.95;
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
        family = fontName;
        style = "bold_italic";
      };

      # Weird, but it works...
      size =
        if isWayland
        then fontSize * 1.05
        else fontSize;
    };
  };

  alacritty-theme = pkgs.fetchgit {
    rev = "808b81b2e88884e8eca5d951b89f54983fa6c237";
    url = "https://github.com/alacritty/alacritty-theme";
    hash = "sha256-g5tM6VBPLXin5s7X0PpzWOOGTEwHpVUurWOPqM/O13A=";
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

    theme = mkStrOpt "argonaut" ''
      The Alacritty theme to use.
      # See https://github.com/alacritty/alacritty-theme/tree/master/themes
    '';

    font = {
      size = mkOpt number 10 "Font package to use";
      package = mkNullOpt package null "Font package to use";
      name = mkStrOpt "CartographCF Nerd Font" "Font name to use";
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
    programs.alacritty = {inherit (cfg) package enable;};

    home.packages =
      optional (cfg.font.package != null)
      cfg.font.package;

    xdg.configFile."alacritty/themes" = {
      source = "${alacritty-theme}/themes";
      recursive = true;
    };
    xdg.configFile."alacritty/alacritty.yml".text =
      replaceTextInFile ["theme" "font"]
      [cfg.theme cfg.font.name]
      ./alacritty.yml;

    # xdg.configFile."alacritty/alacritty.yml" = mkIf (cfg.settings != {}) {
    #   text = let
    #     config = yamlFormat.generate "alacritty.yml" cfg.settings;
    #   in
    #     ''
    #       import:
    #         - "~/.config/alacritty/themes/${cfg.theme}.yaml"
    #     ''
    #     + builtins.readFile config;
    # };
  };
}
