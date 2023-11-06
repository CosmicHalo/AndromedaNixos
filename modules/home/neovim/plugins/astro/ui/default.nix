# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.neovim;
  cfgAstroUI = cfg.plugins.astroui;
in {
  options.milkyway.apps.neovim.plugins.astroui = with types; {
    colorscheme = mkOpt str "astrodark" "Colorscheme to use";

    highlights =
      mkOpt (attrsOf vim.highlightType) {}
      "Override highlights in any colorscheme";

    icons =
      mkOpt (attrsOf str) {}
      "A table of icons in the UI using NERD fonts"
      // {
        example = ''
          icons = {
            GitAdd = "",
          },
        '';
      };
    text_icons =
      mkOpt (attrsOf str) {}
      "A table of only text icons used when icons are disabled"
      // {
        example = ''
          icons = {
            GitAdd = "",
          },
        '';
      };

    status = mkCompositeOption' "Configuration table of AstroNvim features" {
      attributes =
        mkOpt (attrsOf attrs) {}
        "
          Configure attributes of components defined in the `status` API.
          Check the AstroNvim documentation for a complete list of color names, this applies to colors that have `_fg` and/or `_bg` names with the suffix removed (ex. `git_branch_fg` as attributes from `git_branch`)
        ";

      colors =
        mkOpt (attrsOf str) {}
        "
          Configure colors of components defined in the `status` API. 
          Check the AstroNvim documentation for a complete list of color names.
        ";

      icon_highlights = mkCompositeOption' "Configure which icons that are highlighted based on context" {
        breadcrumbs = mkBoolOpt false "Enable or disable breadcrumb icon highlighting";

        file_icon = mkCompositeOption' "Enable or disable the highlighting of filetype icons both in the statusline and tabline" {
          tabline =
            mkOpt lines "" "Tabline function to use for filetype icons"
            // {apply = lines: vim.mkRaw lines;};

          statusline =
            mkBoolOpt true
            "Enable or disable filetype icon highlighting in the statusline";
        };
      };

      separators = let
        mkSeperatorOpt = desc: mkOpt (either str (listOf str)) [] desc;
      in
        mkCompositeOption' "Configure characters used as separators for various elements" {
          tab = mkSeperatorOpt "Configure separators for tab elements";
          left = mkSeperatorOpt "Configure separators for left elements";
          path = mkSeperatorOpt "Configure separators for path elements";
          right = mkSeperatorOpt "Configure separators for right elements";
          center = mkSeperatorOpt "Configure separators for center elements";
          breadcrumbs = mkSeperatorOpt "Configure separators for breadcrumbs elements";
          none = mkSeperatorOpt "Configure separators for elements that have no separators";
        };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "nvim/lua/plugins/astroui.lua".text = ''
        return {
          "AstroNvim/astroui",
          lazy = false, -- disable lazy loading
          priority = 10000, -- load AstroCore first
          ---@type AstroUIConfig
          opts = {
            -- easily configure auto commands
            colorscheme = ${vim.toLuaObject cfgAstroUI.colorscheme},

            -- Override highlights in any colorscheme
            -- Keys can be:
            --   `init`: table of highlights to apply to all colorschemes
            --   `<colorscheme_name>` override highlights in the colorscheme with name: `<colorscheme_name>`
            highlights = ${vim.toLuaObject cfgAstroUI.highlights},
            icons = ${vim.toLuaObject cfgAstroUI.icons},
            textIcons = ${vim.toLuaObject cfgAstroUI.text_icons},
            status = ${vim.toLuaObject cfgAstroUI.status},
          },
        }
      '';
    };
  };
}
