{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.zoxide;
in {
  options.milkyway.programs.zoxide = with types; {
    enable = mkEnableOption "Zoxide";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zoxide
    ];
  };
}
