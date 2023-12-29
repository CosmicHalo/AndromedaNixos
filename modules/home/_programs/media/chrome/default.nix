{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.programs.google-chrome;
in {
  options.milkyway.programs.google-chrome = with types; {
    enable = mkEnableOption "Google Chrome";
    package = mkPackageOpt pkgs.google-chrome "Google Chrome";
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
