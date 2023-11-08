# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.neovim;
in {
  options.milkyway.apps.neovim.optionscfg = with types;
    mkOpt lines ''''
    ''
      [Options] to be applied to AstroNvim.

      [Options] are automatically loaded before lazy.nvim startup.
      Default options that are always set: https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/options.lua.
    ''
    // {
      example = ''
        vim.opt.number = true -- sets vim.opt.number
        vim.g.mapleader = " " -- sets vim.g.mapleader
        vim.opt.relativenumber = false -- sets vim.opt.relativenumber
      '';
    };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "nvim/lua/config/options.lua".text = concatStrings [
        ''
          -- Options are automatically loaded before lazy.nvim startup
          -- Default options that are always set: https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/options.lua
          -- Add any additional options here
        ''
        cfg.optionscfg
      ];
    };
  };
}
