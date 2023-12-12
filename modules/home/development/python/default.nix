{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.development.python;
in {
  options.milkyway.development.python = with types; {
    enable = mkEnableOption "Python programming language.";
    package = mkPackageOpt pkgs.python3Full "Python package to install.";
    python2 = mkEnableOpt "Python 2.x";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        cfg.package
      ]
      ++ lib.optional cfg.python2.enable python2;
  };
}
