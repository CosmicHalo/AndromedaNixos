{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.milkyway.services.envfs;

  inherit (lib.milkyway) mkEnableOpt;
in {
  options.milkyway.services.envfs = mkEnableOpt "envfs";

  config = mkIf cfg.enable {
    services.envfs.enable = true;
  };
}
