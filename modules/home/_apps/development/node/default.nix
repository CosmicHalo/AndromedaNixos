{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.nodejs;
  cfgRush = config.milkyway.apps.nodejs.rush;
in {
  options.milkyway.apps.nodejs = with types; {
    enable = mkEnableOption "Nodejs";

    rush = {
      enable = mkEnableOption "Rush.js";
      package = mkOpt package pkgs.nodePackages.rush "Rush.js package";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfgRush.package
    ];
  };
}
