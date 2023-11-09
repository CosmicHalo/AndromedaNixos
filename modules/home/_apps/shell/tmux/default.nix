{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.tmux;
in {
  options.milkyway.apps.tmux = {
    enable = mkEnableOption "Tmux";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      milkyway.tmux
    ];
  };
}
