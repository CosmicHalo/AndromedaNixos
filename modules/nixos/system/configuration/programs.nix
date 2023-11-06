{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.system.configuration;
in {
  /*
   ************************
  * COMMON CONFIGURATIONS *
  ************************
  */

  config = mkIf cfg.enable {
    # Default applications
    environment.systemPackages = with pkgs; [
      autorandr
      killall
      nvd
      rsync
      stow
      sysz
      tldr
      ugrep
      wget
      xorg.xrandr
    ];

    programs = {
      # Fix (read: workaround) an issue with Sqlite
      command-not-found.enable = mkDefault false;
      nix-index-database.comma.enable = mkDefault true;
    };
  };
}
