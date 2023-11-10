{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.development.nodejs;
  cfgRush = config.milkyway.development.nodejs.rush;
in {
  options.milkyway.development.nodejs = with types; {
    enable = mkEnableOption "Nodejs";
    version = mkPackageOpt pkgs.nodejs_18 "Nodejs version";

    rush = {
      enable = mkEnableOption "Rush.js";
      package = mkOpt package pkgs.nodePackages.rush "Rush.js package";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      [
        cfg.version
      ]
      ++ optional cfgRush.enable cfgRush.package;
  };
}
