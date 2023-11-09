{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.firedragon;
in {
  options.milkyway.apps.firedragon = mkEnableOpt "firedragon";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      firedragon
    ];

    xdg.mimeApps.defaultApplications = let
      urls = [
        "text/html"
        "x-scheme-handler/about"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/unknown"
      ];
    in
      lib.genAttrs urls (_: ["firedragon.desktop"]);
  };
}
