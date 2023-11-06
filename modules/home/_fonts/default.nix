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
    fonts = mkOpt (listOf package) [] "Custom font packages to install.";
  };

  options.milkyway.home.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    fonts = mkOpt (listOf package) [] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    fonts.fontconfig = enabled;
    home.packages = with pkgs;
      [
        # Fonts
        anonymousPro
        input-fonts
        martian-mono
        noto-fonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji

        # icon fonts
        material-symbols

        # nerdfonts
        (pkgs.nerdfonts.override {
          fonts = [
            # "3270"
            # "Agave"
            # "BigBlueTerminal"
            "CascadiaCode"
            "DaddyTimeMono"
            # "DroidSansMono"
            "FiraCode"
            "FiraMono"
            # "Go-Mono"
            "Hack"
            # "Hermit"
            # "InconsolataLGC"
            # "IosevkaTerm"
            # "JetBrainsMono"
            # "Lekton"
            # "Lilex"
            # "MPlus"
            # "Meslo"
            # "Monofur"
            # "Monoid"
            # "Mononoki"
            # "NerdFontsSymbolsOnly"
            # "OpenDyslexic"
            # "ProFont"
            # "RobotoMono"
            "SourceCodePro"
            # "SpaceMono"
            "UbuntuMono"
            # "VictorMono"
            # "iA-Writer"
          ];
        })
      ]
      ++ cfg.fonts;
  };
}
