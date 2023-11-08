# This is the lazy file within nvim/lua/config
{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.neovim.astronvim;
  lazyCfg = config.milkyway.apps.neovim.lazycfg;
in {
  options.milkyway.apps.neovim.lazycfg = with types; {
    lazy = mkBoolOpt true "Enable lazy loading of plugins";

    colorscheme =
      mkOpt (listOf str) ["astrodark" "habamax" "catppuccin"]
      "List of colorschemes to install";

    spec =
      mkNullOrOption lines "Lazy config specification"
      // {
        example = ''
          { "AstroNvim/AstroNvim", branch = "v4", version = USE_STABLE and "^4" or nil, import = "astronvim.plugins" },
          -- pin plugins to known working versions
          { import = "astronvim.lazy_snapshot", cond = USE_STABLE },

          -- import/override with your plugins
          { import = "plugins" },
        '';

        apply = cfg:
          ifNonNull' cfg
          (vim.mkRaw cfg);
      };
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      # Core Lazy Config
      "nvim/lua/config/lazy.lua".text =
        replaceTextInFile ["lazy" "colorscheme" "spec"]
        [(vim.toLuaObject lazyCfg.lazy) (vim.toLuaObject lazyCfg.colorscheme) (vim.toLuaObject lazyCfg.spec)]
        ./lazy.lua;
    };
  };
}
