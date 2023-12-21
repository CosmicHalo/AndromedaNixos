{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.graphite;
in {
  options.milkyway.apps.graphite = {
    enable = mkEnableOption "Graphite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      graphite-cli
    ];
  };
}
