{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.gparted;
in {
  options.milkyway.apps.gparted = mkEnableOpt "gparted";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [gparted];
  };
}
