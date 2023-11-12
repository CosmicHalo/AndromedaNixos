{
  lib,
  pkgs,
  config,
  virtual,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.security;
  cfgSudo = cfg.sudo;
in {
  options.milkyway.security = with lib.types; {
    keyring = mkEnableOpt "desktop keyring";

    acme = {
      enable = mkEnableOption "default ACME configuration";
      email = mkOpt str config.milkyway.user.email "The email to use.";
      staging = mkOpt bool virtual "Whether to use the staging server or not.";
    };

    sudo = {
      enable = mkBoolOpt true "Whether to enable sudo or not.";
      sudo-rs = mkEnableOpt "sudo-rs";

      package = mkPackageOpt (
        if cfgSudo.sudo-rs.enable
        then pkgs.sudo-rs
        else pkgs.sudo
      ) "The package to use for sudo.";

      extraConfig =
        mkLinesOpt ''''
        "Extra configuration to add to the sudoers file.";
    };
  };

  config = mkMerge [
    (mkIf cfgSudo.enable {
      # We want to be insulted on wrong passwords
      security = let
        sudoCmd =
          if cfgSudo.sudo-rs.enable
          then "sudo-rs"
          else "sudo";
      in {
        "${sudoCmd}" = {
          enable = true;

          extraConfig = concatStrings [
            ''
              Defaults env_reset
              Defaults pwfeedback, insults
              Defaults timestamp_timeout=15
            ''

            cfgSudo.extraConfig
          ];

          inherit (cfgSudo) package;
        };
      };
    })

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
