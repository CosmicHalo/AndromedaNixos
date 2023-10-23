{
  lib,
  config,
  ...
}:
with lib; let
  inherit (lib.milkyway) mkEnableOpt mkOpt;
  cfg = config.milkyway.services.btrfs-maintenance;
in {
  options.milkyway.services.btrfs-maintenance = with types; {
    enable = mkEnableOption "Installs and enables some filesystem optimizations for BTRFS.";

    autoScrub = mkEnableOpt "BTRFS filesystem scrubbing";
    deduplication = mkEnableOpt "BTRFS filesystem optimizations";

    uuid =
      mkOpt (nullOr str) null
      "The UUID of the BTRFS filesystem to deduplicate.";
  };

  config = mkIf cfg.enable {
    # Filesystem deduplication in the background
    services.beesd.filesystems = mkIf (cfg.deduplication.enable && cfg.uuid != null) {
      root = {
        verbosity = "crit";
        hashTableSizeMB = 2048;
        spec = "UUID=${cfg.uuid}";
        extraOptions = ["--loadavg-target" "1.0"];
      };
    };

    # Enable regular scrubbing of BTRFS filesystems
    services.btrfs.autoScrub.enable = cfg.autoScrub.enable;
  };
}
