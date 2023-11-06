{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
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
