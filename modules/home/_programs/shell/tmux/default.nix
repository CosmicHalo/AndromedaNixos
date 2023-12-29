{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.tmux;
in {
  options.milkyway.programs.tmux = {
    enable = mkEnableOption "Tmux";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      milkyway.tmux
    ];
  };
}
