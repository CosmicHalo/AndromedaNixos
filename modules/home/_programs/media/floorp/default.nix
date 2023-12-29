{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.floorp;
in {
  options.milkyway.programs.floorp = mkEnableOpt "floorp";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      floorp
    ];
  };
}
