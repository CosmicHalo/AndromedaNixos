{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.gparted;
in {
  options.milkyway.programs.gparted = mkEnableOpt "gparted";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [gparted];
  };
}
