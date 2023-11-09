{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.milkyway.apps.bitwarden;
  cfgRbw = config.milkyway.apps.bitwarden.rbw;
in {
  options.milkyway.apps.bitwarden = {
    enable = mkEnableOption "Bitwarden Apps";

    rbw = {
      enable = mkEnableOption "Unofficial command line client for Bitwarden";
      settings = {
        email = mkStrOpt config.milkyway.user.email "Bitwarden email";
        pinentry = mkStrOpt config.milkyway.user.pinentry "Bitwarden pinentry";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.rbw = mkIf cfgRbw.enable {
      enable = true;
      inherit (cfgRbw) settings;
    };

    home = {
      packages = with pkgs; [
        # bitwarden
        bitwarden-cli
        bitwarden-menu
      ];
    };
  };
}
