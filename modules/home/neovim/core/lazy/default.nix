# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.neovim;
  lazyCfg = config.milkyway.apps.neovim.lazycfg;
in {
  options.milkyway.apps.neovim.lazycfg = with types; {
    lazy = mkBoolOpt true "Enable lazy loading of plugins";

    colorscheme =
      mkOpt (listOf str) ["astrodark" "habamax" "catppuccin"]
      "List of colorschemes to install";
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      # Core Lazy Config
      "nvim/lua/config/lazy.lua".text =
        replaceTextInFile ["lazy" "colorscheme"]
        [(vim.toLuaObject lazyCfg.lazy) (vim.toLuaObject lazyCfg.colorscheme)]
        ./lazy.lua;
    };
  };
}
