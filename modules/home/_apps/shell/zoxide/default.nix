{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.shell.zoxide;
in {
  options.milkyway.shell.zoxide = with types; {
    enable = mkEnableOption "Zoxide";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zoxide
    ];
  };
}
