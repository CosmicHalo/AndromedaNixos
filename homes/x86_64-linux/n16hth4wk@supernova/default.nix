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
    };

    #*********
    #* System
    #*********
    shell = {
      git = {
        enable = true;
        signingKey = "C505 1E8B 06AC 1776 6875  1B60 93AF DAD0 10B3 CB8D";
      };

      ssh = {
        enable = true;
        ssh-agent = enabled;

        matchBlocks = {
          "work" = {
            hostname = "192.168.1.188";
            user = "jlecoq@dnanexus.com";
          };

          "builder" = {
            user = "n16hth4wk";
            hostname = "74.208.105.72";
          };

          "builder-root" = {
            user = "root";
            hostname = "74.208.105.72";
          };
        };
      };
    };

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
