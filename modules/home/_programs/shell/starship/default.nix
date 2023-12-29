{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.starship;
in {
  options.milkyway.programs.starship = {
    enable = mkEnableOption "Starship";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = pkgs.lib.importTOML ./starship.toml;
    };
  };
}
