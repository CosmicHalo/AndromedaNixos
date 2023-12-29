# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  nvimPath,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.neovim.astronvim;
  cfgAstroCore = cfg.astrocore;

  autocmdOpt = types.submodule {
    options = {
      desc = mkOpt types.str "" "Description of autocmd";
      callback = mkOpt types.lines "" "Callback to run on autocmd";
      event = mkOpt (types.listOf types.str) [] "Event to trigger autocmd";
    };
  };

  commandOpt = types.submodule {
    options = {
      action =
        mkOpt types.lines ""
        "Action to run on command";

      desc =
        mkOpt types.str ""
        "Description of command";
    };
  };
in {
  options.milkyway.programs.neovim.astronvim.astrocore = with types; {
    autocmds =
      mkOpt (attrsOf autocmdOpt) {} "Easily configure auto commands"
      // {
        apply = autoCommands:
          mapAttrs (_: autocmd: autocmd // {callback = vim.mkRaw autocmd.callback;})
          autoCommands;
      };

    commands =
      mkOpt (attrsOf commandOpt) {} "Easily configure user commands"
      // {
        apply = commands:
          mapAttrs (_: cmd: {
            inherit (cmd) desc;
            "__unkeyed" = vim.mkRaw cmd.action;
          })
          commands;
      };

    mappings =
      vim.keymaps.mkKeymaps
      "Configuration table of AstroNvim features";

    on_keys =
      mkOpt (attrsOf (listOf lines)) {} "Easily configure functions on key press"
      // {
        apply = keys:
          mapAttrs (_: keyFn: map vim.mkRaw keyFn)
          keys;
      };

    features = mkCompositeOption' "Configuration table of AstroNvim features" {
      cmp = mkBoolOpt true "Enable completion";
      autopairs = mkBoolOpt true "Enable autopairs";
      highlighturl = mkBoolOpt true "Highlight URLs";
      notifications = mkBoolOpt true "Enable notifications";

      max_file = mkCompositeOption' "Global limits for large files" {
        lines = mkOpt int 10000 "Max file lines";
        size = mkOpt int (1024 * 100) "Max file size";
      };
    };

    git_worktrees =
      mkNullOpt (listOf attrs) null "Enable git integration for detached worktrees"
      // {
        apply = worktrees:
          ifNonNull' worktrees
          (map (tree: lib.mapAttrs (_: v: vim.mkRaw v) tree)
            worktrees);

        example = ''
          [
            { toplevel = vim.env.HOME, gitdir = vim.env.HOME .. "/.dotfiles" },
          ]
        '';
      };

    sessions = mkCompositeOption' "Configuration table of session options for AstroNvim's session management powered by Resession" {
      autosave = mkCompositeOption' "Configure auto saving" {
        last = mkBoolOpt true "Auto save last session";
        cwd = mkBoolOpt true "Auto save session for each working directory";
      };

      ignore = mkCompositeOption' "Patterns to ignore when saving sessions" {
        filetypes = mkOpt (listOf str) [] "Filetypes to ignore sessions";
        buftypes = mkOpt (listOf str) [] "Buftypes to ignore sessions";
        dirs = mkOpt (listOf str) [] "working directories to ignore sessions in";
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = let
      opts =
        ''
          -- configure AstroNvim features
          features = ${vim.toLuaObject cfgAstroCore.features},
        ''
        + (mkStringIfNonEmpty cfgAstroCore.autocmds ''
          -- easily configure auto commands
          autocmds = ${vim.toLuaObject cfgAstroCore.autocmds},
        '')
        + (mkStringIfNonEmpty cfgAstroCore.commands ''
          -- easily configure user commands
          commands = ${vim.toLuaObject cfgAstroCore.commands},
        '')
        + (mkStringIfNonEmpty cfgAstroCore.on_keys ''
          -- Configuration of vim mappings to create
          mappings = ${vim.toLuaObject cfgAstroCore.mappings},
        '')
        + (mkStringIfNonEmpty cfgAstroCore.on_keys ''
          -- easily configure functions on key press
          on_keys = ${vim.toLuaObject cfgAstroCore.on_keys},
        '')
        + (mkStringIfNonNull cfgAstroCore.git_worktrees ''
          -- Enable git integration for detached worktrees
          git_worktrees = ${vim.toLuaObject cfgAstroCore.git_worktrees},
        '')
        + (mkStringIfNonEmpty cfgAstroCore.sessions ''
          -- Configuration table of session options for AstroNvim's session management powered by Resession
          sessions = ${vim.toLuaObject cfgAstroCore.sessions},
        '');
    in {
      "${nvimPath}/astrocore.lua".text = ''
        return {
          "AstroNvim/astrocore",
          dependencies = { "nvim-lua/plenary.nvim" },
          lazy = false, -- disable lazy loading
          priority = 10000, -- load AstroCore first
          ---@type AstroCoreOpts
          opts = {
            ${opts}
          },
        }
      '';
    };
  };
}
