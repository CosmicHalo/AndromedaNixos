{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.milkyway.hardware.btrfs;

  inherit (lib) mkEnableOption mkIf;
in {
  options.milkyway.hardware.btrfs = {
    enable = mkEnableOption "BTRFS support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btrfs-assistant
      # btrfs-progs
      # btrfs-snap
      # snapper
      # snapper-gui
      # timeshift
    ];
  };
}
