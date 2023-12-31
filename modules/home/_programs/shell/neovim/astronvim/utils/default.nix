{
  lib,
  config,
  ...
}: let
  cfg = config.milkyway.programs.neovim.astronvim;
in
  lib.mkIf cfg.enable {
    xdg.configFile."nvim/lua/utils" = {
      source = ./lua;
      recursive = true;
    };
  }
