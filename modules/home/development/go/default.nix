{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.development.go;
in {
  options.milkyway.development.go = with types; {
    enable = mkEnableOption "Go programming language.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
    ];
  };
}
