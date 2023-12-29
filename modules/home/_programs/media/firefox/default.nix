# {
#   lib,
#   pkgs,
#   config,
#   ...
# }:
# with lib;
# with lib.milkyway; let
#   cfg = config.milkyway.programs.firefox;
#   urls = [
#     "text/html"
#     "x-scheme-handler/about"
#     "x-scheme-handler/http"
#     "x-scheme-handler/https"
#     "x-scheme-handler/unknown"
#   ];
# in {
#   options.milkyway.programs.firefox = {
#     enable = mkEnableOption "Firefox";
#     defaultBrowser = mkBoolOpt false "Set Firefox as the default browser";
#   };
#   config = mkIf cfg.enable {
#     home.packages = with pkgs; [
#       firefox
#     ];
#     # xdg.mimeApps.defaultApplications =
#     #   mkIf cfg.defaultBrowser
#     #   (lib.genAttrs urls (_: ["firefox.desktop"]));
#   };
# }
_: {}
