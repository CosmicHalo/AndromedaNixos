{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.graphite;
in {
  options.milkyway.programs.graphite = {
    enable = mkEnableOption "Graphite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      graphite-cli
    ];
  };
}
