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

    version =
      mkPackageOpt pkgs.nodejs_18
      "Nodejs version";

    rush = {
      enable = mkEnableOption "Rush.js";
      package =
        mkOpt package pkgs.nodePackages.rush
        "Rush.js package";
    };

    extraNodePackages =
      mkListOpt types.package []
      "Extra Node.js packages to install";
  };

  config = mkIf cfg.enable {
    milkyway.home.sessionPath = ["${config.home.homeDirectory}/.local/share/pnpm"];

    home.sessionVariables = {
      PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
    };

    home.packages = with pkgs;
      [
        cfg.version
        corepack_21
        nodePackages_latest.pnpm
      ]
      ++ cfg.extraNodePackages
      ++ optional cfgRush.enable cfgRush.package;
  };
}
