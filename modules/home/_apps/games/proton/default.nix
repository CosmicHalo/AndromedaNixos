{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfgProton = config.milkyway.apps.proton;
  cfgProtonTricks = config.milkyway.apps.protontricks;
in {
  options.milkyway.apps.proton = mkEnableOpt "proton-caller";
  options.milkyway.apps.protontricks = mkEnableOpt "protontricks";

  config = {
    home.packages =
      lib.optional cfgProton.enable pkgs.proton-caller
      ++ lib.optional cfgProtonTricks.enable pkgs.protontricks;
  };
}
