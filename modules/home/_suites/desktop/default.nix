{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.suites.desktop;
in {
  options.milkyway.suites.desktop = with types; {
    enable = mkEnableOption "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    milkyway = {
      programs = {
        discord = enabled;
        # slack = enabled;
      };
    };
  };
}
