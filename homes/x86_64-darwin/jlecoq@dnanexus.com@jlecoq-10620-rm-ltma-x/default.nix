{
  lib,
  pkgs,
  ...
}:
with lib.milkyway; {
  imports = [
    ./programs
  ];

  milkyway = {
    user = {
      enable = true;
      email = "jlecoq@dnanexus.com";
    };

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
      aws-cli = enabled;
      go-task = enabled;
      zoxide = enabled;
      vscode = enabled;

      kitty = {
        enable = true;
        font = {
          size = 11;
          name = "Biscuit";
        };
      };

      nodejs = {
        enable = true;
        rush = enabled;
      };
    };

    tools.rtx = enabled;

    shell = {
      git = {
        enable = true;
        signingKey = "C505 1E8B 06AC 1776 6875  1B60 93AF DAD0 10B3 CB8D";
      };

      ssh = {
        enable = true;
        ssh-agent = enabled;

        matchBlocks = {
          "home" = {
            user = "n16hth4wk";
            hostname = "supernova";
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
