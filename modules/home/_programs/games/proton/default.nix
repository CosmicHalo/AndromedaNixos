{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfgProton = config.milkyway.programs.proton;
  cfgProtonTricks = config.milkyway.programs.protontricks;
in {
  options.milkyway.programs.proton = mkEnableOpt "proton-caller";
  options.milkyway.programs.protontricks = mkEnableOpt "protontricks";

  config = {
    home.packages =
      lib.optional cfgProton.enable pkgs.proton-caller
      ++ lib.optional cfgProtonTricks.enable pkgs.protontricks;
  };
}
