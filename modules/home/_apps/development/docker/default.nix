{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.docker;
in {
  options.milkyway.apps.docker = with types; {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      docker
      docker-ls
      docker-gc
      docker-sync
    ];
  };
}
