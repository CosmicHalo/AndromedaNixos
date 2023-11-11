{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfgSddm = cfg.sddm;
  cfgUser = config.milkyway.user;
  cfg = config.milkyway.desktop.kde;

  isChaoticEnabled = isNyxEnabled config;
in {
  imports = [
    ./apps.nix
    #   ./config.nix
  ];

  options.milkyway.desktop.kde = with types; {
    enable = mkBoolOpt false "Whether or not to use KDE Plasam 5 as the desktop environment.";
    wayland = mkBoolOpt false "Whether or not to use Wayland.";

    extraPackages =
      mkOpt (listOf package) []
      "Extra KDE packages to install.";
    extraExcludePackages =
      mkOpt (listOf package) []
      "Extra packages to exclude install.";

    sddm = {
      autologin =
        mkBoolOpt false
        "Whether or not to enable autologin.";
      autoNumlock =
        mkBoolOpt false
        "Whether or not to enable numlock on boot.";
      theme =
        mkOpt str "catppuccin"
        "Default SDDM Theme to use.";
      themes =
        mkOpt (listOf package) []
        "Extra SDDM themes to install.";
      setupScript = mkOpt str ''
        xrandr --auto
      '' "Script to run on SDDM startup.";
    };
  };

  config = mkIf cfg.enable {
    # Allow GTK applications to show an appmenu on KDE
    chaotic.appmenu-gtk3-module.enable = mkIf isChaoticEnabled true;

    #***********
    # Milkyway
    #***********
    milkyway = {
      # Set the desktop theme to KDE
      desktop.platformTheme = "kde";

      # # Addons
      # desktop.addons = {
      #   foot = enabled;
      #   wallpapers = enabled;
      # };

      home.extraOptions.dconf.enable = true;
    };

    programs = {
      kdeconnect.enable = mkDefault true;
      partition-manager.enable = mkDefault true;
    };

    services.xserver = {
      enable = true;

      /*
       ***********
      * MANAGERS *
      ***********
      */
      desktopManager.plasma5.enable = true;
      displayManager.defaultSession = mkIf cfg.wayland "plasmawayland";

      displayManager.sddm = {
        enable = true;

        inherit (cfgSddm) theme;
        inherit (cfgSddm) autoNumlock;
        inherit (cfgSddm) setupScript;
        autoLogin.relogin = cfgSddm.autologin;

        settings = {
          Autologin = mkIf cfgSddm.autologin {
            Session = mkDefault "plasma";
            User = mkDefault "${cfgUser.name}";
          };

          General = {
            Font = mkDefault "Monaspace Krypton";
            CursorTheme = mkDefault "Sweet-cursors";
          };
        };
      };

      excludePackages = [pkgs.xterm];
    };
  };
}
