{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkEnableOption optional;
  inherit (lib.milkyway) mkOpt mkEnableOpt;

  cfg = config.milkyway.security;
in {
  options.milkyway.security = with lib.types; {
    keyring = mkEnableOpt "desktop keyring";

    acme = {
      enable = mkEnableOption "default ACME configuration";
      email = mkOpt str config.milkyway.user.email "The email to use.";
      staging = mkOpt bool virtual "Whether to use the staging server or not.";
    };
  };

  config = mkMerge [
    {
      # We want to be insulted on wrong passwords
      security.sudo.extraConfig = ''
        Defaults pwfeedback
        Defaults insults
      '';
    }

    (mkIf cfg.keyring.enable {
      environment.systemPackages = with pkgs; [
        gnome.gnome-keyring
        gnome.libgnome-keyring
      ];
    })

    (mkIf cfg.acme.enable {
      security.acme = {
        acceptTerms = true;

        defaults = {
          inherit (cfg) email;

          group = mkIf config.services.nginx.enable "nginx";
          server = mkIf cfg.staging "https://acme-staging-v02.api.letsencrypt.org/directory";

          # Reload nginx when certs change.
          reloadServices = optional config.services.nginx.enable "nginx.service";
        };
      };
    })
  ];
}
