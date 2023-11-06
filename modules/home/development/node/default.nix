{
  lib,
  pkgs,
  flake,
  config,
  ...
}:
with lib;
with flake.lib.milkyway; let
  cfg = config.milkyway.development.nodejs;
  cfgRush = config.milkyway.development.nodejs.rush;
in {
  options.milkyway.development.nodejs = with types; {
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
