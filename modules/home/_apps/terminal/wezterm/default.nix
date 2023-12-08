{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.wezterm;
in {
  options.milkyway.apps.wezterm = with types; {
    enable = mkEnableOption "wezterm";

    font = {
      size = mkOpt number 10.0 "Font size to use";
      name = mkOpt str "ComicShannsMono Nerd Font" "Font name to use";
      package = mkOpt (nullOr package) null "Font package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      optionals
      (!builtins.isNull
      cfg.font.package) [cfg.font.package];

    programs.wezterm = {
      enable = true;

      extraConfig = ''
        local wezterm = require "wezterm"

        -- wezterm.gui is not available to the mux server, so take care to
        -- do something reasonable when this config is evaluated by the mux
        function get_appearance()
          if wezterm.gui then
            return wezterm.gui.get_appearance()
          end
          return 'Dark'
        end

        function scheme_for_appearance(appearance)
          if appearance:find 'Dark' then
            return 'Catppuccin Mocha'
          else
            return 'Catppuccin Latte'
          end
        end

        return {
          check_for_updates = true,
          color_scheme = scheme_for_appearance(get_appearance()),

          enable_scroll_bar = true,
          scrollback_lines = 10000,
          enable_kitty_keyboard = true,
          default_cursor_style = 'SteadyBar',
          hide_tab_bar_if_only_one_tab = true,

          -- default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },

          font_size = ${toString cfg.font.size},
          -- font = wezterm.font("${cfg.font.name}"),

          keys = {
            {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
          }
        }
      '';
    };
  };
}
