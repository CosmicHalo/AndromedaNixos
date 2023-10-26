{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.milkyway) mkEnableOpt;

  cfg = config.milkyway.apps.bitwarden;
in {
  options.milkyway.apps.bitwarden = mkEnableOpt "Bitwarden Apps/CLI";

  config = mkIf cfg.enable {
    programs.rbw = {
      enable = true;

      settings = {
        inherit (config.milkyway.user) email;
        pinentry = config.services.gpg-agent.pinentryFlavor;
      };
    };

    home = {
      packages = with pkgs; [
        bitwarden
        bitwarden-cli
        bitwarden-menu
        bws
      ];
    };
  };
}
