{
  lib,
  config,
  ...
}: let
  cfg = config.milkyway.apps.neovim.astronvim;
  luaFiles = lib.milkyway.get-lua-files ./lua;
in {}
# lib.mkIf cfg.enable {
#   xdg.configFile = lib.foldl' (acc: luaFile: let
#     fileName = builtins.baseNameOf luaFile;
#     filePath = "nvim/lua/plugins/${builtins.unsafeDiscardStringContext fileName}";
#   in
#     acc
#     // {
#       "${filePath}".text = builtins.readFile luaFile;
#     }) {}
#   luaFiles;
# }

