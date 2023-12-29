{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.go-task;
in {
  options.milkyway.programs.go-task = with types; {
    enable = mkEnableOption "Task Command Line Tool [Go]";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go-task
    ];
  };
}
