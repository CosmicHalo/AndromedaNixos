{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.zoxide;
in {
  options.milkyway.apps.zoxide = with types; {
    enable = mkEnableOption "Zoxide";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zoxide
    ];
  };
}
