{
  lib,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.desktop;
  # cfgAppImage = config.milkyway.tools.appimage-run;
in {
  options.milkyway.desktop = with types; {
    gtkTheme =
      mkOpt str "Sweet-Dark"
      "GTK theme to use";
    platformTheme =
      mkOpt (enum ["gtk" "gnome" "lxqt" "qt5ct" "kde"]) "gtk"
      "Platform theme to use";
    extraDesktopPackages =
      mkOpt (listOf package) []
      "Extra desktop packages to install";
  };

  config = mkMerge [
    {
      # Set QT theme
      qt.platformTheme = cfg.platformTheme;

      # Fix "the name ca.desrt.dconf was not provided by any .service files"
      # https://nix-community.github.io/home-manager/index.html
      programs.dconf.enable = true;

      # Easy launching of apps via "comma", contains command-not-found database
      programs.command-not-found.enable = mkDefault false;
      programs.nix-index-database.comma.enable = mkDefault true;

      environment = {
        systemPackages = cfg.extraDesktopPackages;

        variables = {
          RADV_VIDEO_DECODE = "1";
          GTK_THEME = cfg.gtkTheme;
        };
      };
    }

    # (mkIf cfgAppImage.enable {
    #   # Run Appimages with appimage-run
    #   boot.binfmt.registrations = genAttrs ["appimage" "AppImage"] (ext: {
    #     magicOrExtension = ext;
    #     recognitionType = "extension";
    #     interpreter = "/run/current-system/sw/bin/appimage-run";
    #   });
    # })
  ];
}
