{
  lib,
  config,
  ...
}: let
  cfg = config.milkyway.apps.neovim.astronvim;
in
  lib.mkIf cfg.enable {
    xdg.configFile."nvim/lua/plugins/user.lua".text = builtins.readFile ./user.lua;
    xdg.configFile."nvim/lua/plugins/mappings.lua".text = builtins.readFile ./mappings.lua;
    xdg.configFile."nvim/lua/plugins/colorscheme.lua".text = builtins.readFile ./colorscheme.lua;
  }
