{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.zellij;
in {
  options.milkyway.apps.zellij = with types; {
    enable = mkEnableOption "zellij";
    enableZshIntegration = mkEnableOption "zsh integration";
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "zellij/config.kdl".source = ./config.kdl;
    };

    programs.zellij = {
      enable = true;
      package = pkgs.milkyway.zellij;

      inherit (cfg) enableZshIntegration;
    };
  };
}
