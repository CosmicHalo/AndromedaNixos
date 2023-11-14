# {
#   lib,
#   pkgs,
#   config,
#   ...
# }:
# with lib;
# with lib.milkyway; let
#   cfg = config.milkyway.apps.steam;
#   cfgTinker = config.milkyway.apps.steam;
# in {
#   options.milkyway.apps = {
#     steam = with types; {
#       enable = mkEnableOption "Whether or not to enable support for Steam.";
#       gamescopeSession = mkEnableOpt "Whether or not to enable gamescope session.";
#       extraPackages = mkOpt (listOf package) [] "Extra packages to install for Steam.";
#     };
#     steamtinkerlaunch = mkEnableOpt "Steam Tinker Launch";
#   };
#   config = {
#     home.packages = with pkgs;
#       [
#         steam
#         steam-run
#       ]
#       ++ optionals cfg.enable cfg.extraPackages
#       ++ optional cfgTinker.enable pkgs.steamtinkerlaunch;
#   };
# }
_: {}
