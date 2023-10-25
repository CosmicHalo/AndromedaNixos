{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  localDir = ".local/share";
  cfg = config.milkyway.desktop.kde;
in {
  config = mkIf cfg.enable {
    milkyway = {
      /*
       *************
      * CONFIG DIR *
      *************
      */

      home.file.${localDir} = {
        source = ./local;
        recursive = true;
      };

      #### KDE ################################################################

      home.configFile = {
        "ktimezonedrc".text = ''
          [TimeZones]
          LocalZone=America/Chicago
          ZoneinfoDir=/etc/zoneinfo
          Zonetab=/etc/zoneinfo/zone.tab
        '';

        "plasma-localerc".text = ''
          [Formats]
          LANG=en_US.UTF-8
        '';

        "gtkrc-2.0".source = ./config/gtkrc-2.0;
      };
    };
  };
}
