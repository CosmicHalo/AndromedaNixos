{
  lib,
  pkgs,
  ...
}:
with lib.milkyway; {
  imports = [
    ./programs
  ];

  home.stateVersion = "23.11";

  milkyway = {
    user = enabled;

    #*********
    #* Suites
    #*********
    suites = {
      desktop = enabled;
      development = enabled;
      nix = enabled;
    };

    #*********
    #* Apps
    #*********
    apps = {
      bitwarden = enabled;
      floorp = enabled;
    };

    #*********
    #* System
    #*********
    fonts = {
      enable = true;
      extraFonts = with pkgs; [
        # Fonts
        input-fonts
        martian-mono
        anonymousPro

        # nerdfonts
        (pkgs.nerdfonts.override {
          fonts = [
            "CascadiaCode"
            "DaddyTimeMono"
            "FiraCode"
            "FiraMono"
            "Hack"
            "SourceCodePro"
            "UbuntuMono"
            "VictorMono"
            # "3270"
            # "Agave"
            # "BigBlueTerminal"
            # "DroidSansMono"
            # "Go-Mono"
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
            # "SpaceMono"
            # "iA-Writer"
          ];
        })
      ];
    };
  };
}
