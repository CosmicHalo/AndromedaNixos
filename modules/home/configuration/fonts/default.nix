{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.fonts;
in {
  imports = [
    ./fonts.nix
  ];

  options.milkyway.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    extraFonts = mkOpt (listOf package) [] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    fonts.fontconfig = enabled;
    home.packages = with pkgs;
      [
        noto-fonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji

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
  };
}
