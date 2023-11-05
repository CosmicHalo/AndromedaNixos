{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.floorp;
in {
  options.milkyway.apps.floorp = mkEnableOpt "floorp";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      floorp
    ];
  };
}
