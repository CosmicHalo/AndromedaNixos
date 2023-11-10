{
  lib,
  config,
  ...
}: let
  cfg = config.milkyway.apps.neovim.astronvim;
in
  lib.mkIf cfg.enable {
    xdg.configFile."nvim/lua/utils" = {
      source = ./lua;
      recursive = true;
    };
  }
