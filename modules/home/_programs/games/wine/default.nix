{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.wine;
in {
  options.milkyway.programs.wine = mkEnableOpt "Wine";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      winetricks
      wine-staging
      winePackages.unstable
      wine64Packages.unstable
    ];
  };
}
