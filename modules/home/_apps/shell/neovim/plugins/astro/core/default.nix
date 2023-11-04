# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.neovim;
  cfgAstroCore = cfg.plugins.astrocore;
in {
  options.milkyway.apps.neovim.plugins.astrocore = with types; {
    autocmds = mkOpt attrs {} "Easily configure auto commands";
    commands = mkOpt attrs {} "easily configure user commands";
    mappings = mkOpt attrs {} "Configuration of vim mappings to create";
    on_keys = mkOpt attrs {} "Easily configure functions on key press";

    features = mkCompositeOption {} "Configuration table of AstroNvim features" {
      cmp = mkBoolOpt true "Enable completion";
      autopairs = mkBoolOpt true "Enable autopairs";
      highlighturl = mkBoolOpt true "Highlight URLs";
      notifications = mkBoolOpt true "Enable notifications";

      max_file = mkCompositeOption {} "Global limits for large files" {
        lines = mkOpt int 10000 "Max file lines";
        size = mkOpt int (1024 * 100) "Max file size";
      };
    };

    git_worktrees =
      mkOptWithExample (listOf attrs) []
      "Enable git integration for detached worktrees" ''
        [
          { toplevel = vim.env.HOME, gitdir = vim.env.HOME .. "/.dotfiles" },
        ]
      '';

    sessions = mkCompositeOption {} "Configuration table of session options for AstroNvim's session management powered by Resession" {
      autosave = mkCompositeOption {} "Configure auto saving" {
        last = vim.defaultNullOpts.mkBool true "Auto save last session";
        cwd = mkBoolOpt true "Auto save session for each working directory";
      };

      ignore = mkCompositeOption {} "Patterns to ignore when saving sessions" {
        filetypes = mkOpt (listOf str) [] "Filetypes to ignore sessions";
        buftypes = mkOpt (listOf str) [] "Buftypes to ignore sessions";
        dirs = mkOpt (listOf str) [] "working directories to ignore sessions in";
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "nvim/lua/plugins/astrocore.lua".text = concatStrings [
        ''
          return {
            "AstroNvim/astrocore",
            dependencies = { "nvim-lua/plenary.nvim" },
            lazy = false, -- disable lazy loading
            priority = 10000, -- load AstroCore first
            ---@type AstroCoreOpts
            opts = {
              features = ${vim.toLuaObject cfgAstroCore.features},
              sessions = ${vim.toLuaObject cfgAstroCore.sessions},
            },
          }
        ''
      ];
    };
  };
}
