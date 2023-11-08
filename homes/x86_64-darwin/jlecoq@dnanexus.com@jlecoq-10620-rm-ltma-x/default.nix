{
  lib,
  pkgs,
  ...
}:
with lib.milkyway; {
  imports = [
    ./programs
  ];

  home = {
    stateVersion = "23.11";
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

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
      # bitwarden = enabled;
      # floorp = enabled;
      aws-cli = enabled;
      go-task = enabled;
      zoxide = enabled;
      vscode = enabled;

      nodejs = {
        enable = true;
        rush = enabled;
      };

      rtx = {
        enable = true;

        settings = {
          tools = {
            node = "18";
            python = ["2.7" "3.11"];
          };

          settings = {
            jobs = 16;
            verbose = true;
            asdf_compat = true;
            experimental = true;
          };
        };
      };
    };

    shell = {
      git = {
        enable = true;
        signingKey = "C505 1E8B 06AC 1776 6875  1B60 93AF DAD0 10B3 CB8D";
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
