{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.fonts;
  fontFileOpt = types.submodule {
    options = {
      fontName = mkStrOpt null "The name of the font.";
      source = mkStrOpt null "The path to the font source.";
    };
  };

  ## Get nix files at a given path.
  get-ttf-files = path:
    builtins.filter
    (andromeda.path.has-file-extension "ttf")
    (andromeda.fs.get-files path);

  ttfFiles = map (ttfFile: let
    fontName = builtins.unsafeDiscardStringContext (builtins.baseNameOf ttfFile);
  in {
    source = ttfFile;
    inherit fontName;
  }) (get-ttf-files ./fontDir);
in {
  options.milkyway.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    extraFonts =
      mkOpt (listOf package) []
      "Custom font packages to install.";
    fontFiles =
      mkOpt (listOf fontFileOpt) []
      "Custom font files to install.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    fonts.fontconfig = enabled;

    home.packages = with pkgs;
      [
        # Noto fonts
        noto-fonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji

        # Hack font
        hackgen-nf-font

        # icon fonts
        material-symbols

        # nerdfonts
        (pkgs.nerdfonts.override {
          fonts = [
            "CascadiaCode"
            "FiraCode"
            "FiraMono"
            "Hack"
            "SourceCodePro"
            "UbuntuMono"
            "VictorMono"
          ];
        })
      ]
      ++ cfg.extraFonts;

    home.file = let
      localDir = ".local/share/fonts";
    in
      # Custom fonts
      (lib.foldl' (acc: x:
        acc
        // {"${localDir}/${x.fontName}".source = x.source;}) {}
      (cfg.fontFiles ++ ttfFiles))
      # Default fonts
      // {
        "${localDir}/BerkleyMono".source = ./fontDir/berkley;
        "${localDir}/PragmataPro".source = ./fontDir/pragmata;
        "${localDir}/OpenDyslexic".source = ./fontDir/open-dyslexic;
      };
  };
}
