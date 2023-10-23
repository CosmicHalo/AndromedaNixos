{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.milkyway.services.flatpak;

  inherit (lib.milkyway) mkEnableOpt;
in {
  options.milkyway.services.flatpak = mkEnableOpt "Flatpak";

  config = mkIf cfg.enable {
    xdg.portal.enable = true;
    services.flatpak.enable = true;

    environment.systemPackages = with pkgs; [
      libportal-qt5
      libsForQt5.flatpak-kcm
    ];
  };
}
