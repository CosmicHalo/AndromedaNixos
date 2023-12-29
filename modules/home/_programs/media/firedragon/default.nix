{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.firedragon;
in {
  options.milkyway.programs.firedragon = mkEnableOpt "firedragon";

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
