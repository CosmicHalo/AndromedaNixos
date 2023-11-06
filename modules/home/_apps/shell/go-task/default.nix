{
  lib,
  pkgs,
  flake,
  config,
  ...
}:
with lib;
with flake.lib.milkyway; let
  cfg = config.milkyway.apps.go-task;
in {
  options.milkyway.apps.go-task = with types; {
    enable = mkEnableOption "Task Command Line Tool [Go]";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go-task
    ];
  };
}
