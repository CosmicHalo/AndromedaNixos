{
  lib,
  pkgs,
  inputs,
  config,
  options,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.system.configuration;
in {
  options.milkyway.system.configuration = with types; {
    enable = mkBoolOpt true "Whether or not to enable common system features.";
    nodocs = mkBoolOpt true "Whether or not to disable documentation.";

    console.font =
      mkOpt (nullOr (either str path))
      "${pkgs.terminus_font}/share/consolefonts/ter-120n.psf.gz"
      "The console font to use.";

    locale = {
      keyMap = mkOpt str "us" "The keymap to use.";

      i18n = {
        defaultLocale = mkOpt str "en_US.UTF-8" "The default locale to use.";
        extraSupportedLocales = mkOpt (listOf str) ["en_US.UTF-8"] "The locales to support.";
      };
    };

    # Longitudes and latitudes are in decimal degrees.
    # provider = `manual` or `geoclue2`
    location = {
      inherit (options.location) latitude longitude;
      provider = mkOpt (enum ["manual" "geoclue2"]) "geoclue2" "The location provider to use.";
    };

    time = {
      timeZone = mkOpt str "America/Chicago" "The timezone to use.";
    };

    xkb = {
      xkbOptions = mkOpt str "caps:escape" "The XKB options to use.";
      useXkbConfig = mkBoolOpt true "Whether or not to use the XKB configuration.";
    };
  };

  imports = with inputs; [
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    ./programs.nix
  ];

  config = {
    /*
     ***********
    * LOCATION *
    ***********
    */
    inherit (cfg) location;

    /*
     *********
    * LOCALE *
    *********
    */
    i18n = {
      # inherit (cfg.locale.i18n) defaultLocale;

      # supportedLocales =
      #   options.i18n.supportedLocales.default
      #   ++ cfg.locale.i18n.extraSupportedLocales;

      # extraLocaleSettings = {
      #   LANG = mkForce usLocale;
      #   LC_ADDRESS = mkForce usLocale;
      #   LC_COLLATE = mkForce usLocale;
      #   LC_CTYPE = mkForce usLocale;
      #   LC_IDENTIFICATION = mkForce usLocale;
      #   LC_MEASUREMENT = mkForce usLocale;
      #   LC_MESSAGES = mkForce usLocale;
      #   LC_MONETARY = mkForce usLocale;
      #   LC_NAME = mkForce usLocale;
      #   LC_NUMERIC = mkForce usLocale;
      #   LC_PAPER = mkForce usLocale;
      #   LC_TELEPHONE = mkForce usLocale;
      #   LC_TIME = mkForce usLocale;
      # };
    };

    /*
     **********
    * CONSOLE *
    **********
    */
    console = {
      inherit (cfg.console) font;
      inherit (cfg.xkb) useXkbConfig;
      keyMap = mkForce cfg.locale.keyMap;
    };

    /*
     *******
    * TIME *
    *******
    */
    time.timeZone = cfg.time.timeZone;
    time.hardwareClockInLocalTime = mkDefault true;

    /*
     ******
    * XKB *
    ******
    */
    services.xserver = {
      xkbVariant = mkDefault "";
      layout = cfg.locale.keyMap;
      inherit (cfg.xkb) xkbOptions;
    };

    /*
     ***************************************************************
    * WHO NEEDS DOCUMENTATION WHEN THERE IS THE INTERNET? #BL04T3D *
    ***************************************************************
    */
    documentation = mkIf cfg.nodocs {
      enable = true;
      dev.enable = false;
      doc.enable = false;
      info.enable = false;
      man.enable = false;
      nixos.enable = true;
    };
  };
}
