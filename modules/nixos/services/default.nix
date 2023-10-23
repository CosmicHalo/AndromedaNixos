{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.milkyway.services;
  cfgCommon = config.milkyway.services.common;

  inherit (lib.milkyway) mkEnableOpt mkEnableOpt';
in {
  options.milkyway.services = {
    common = mkEnableOpt' "Common services";
    printing = mkEnableOpt "Printing";
  };
  config = mkMerge [
    (mkIf cfgCommon.enable {
      services = {
        # Handle ACPI events
        acpid.enable = mkDefault true;

        avahi = {
          enable = mkDefault true;
          nssmdns = mkDefault true;
        };

        # Discard blocks that are not in use by the filesystem
        fstrim.enable = mkDefault true;

        # Firmware updater for machine hardware
        fwupd.enable = mkDefault true;

        # Limit systemd journal size
        journald.extraConfig = ''
          SystemMaxUse=500M
          RuntimeMaxUse=10M
        '';

        # Enable locating files via locate
        locate = {
          enable = mkDefault true;
          localuser = null;
          interval = "hourly";
          package = pkgs.plocate;
        };

        # Power profiles daemon
        power-profiles-daemon.enable = mkDefault true;
      };
    })

    # PRINTING
    (mkIf cfg.printing.enable {
      services.printing.enable = true;
    })
  ];
}
