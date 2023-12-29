{
  lib,
  pkgs,
  ...
}:
with lib.milkyway; {
  home.stateVersion = "23.11";

  milkyway = {
    user = enabled;

    #*****************
    #* Shared Configs
    #*****************
    configurations = {
      zsh = enabled;
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
      vscode = enabled;
      bitwarden = enabled;
      google-chrome = enabled;
    };

    #**************
    #* Development
    #**************
    development = {
      ocaml = enabled;
      python = enabled;
      nodejs = {
        enable = true;
        rush = enabled;
      };
    };

    tools.rtx = {
      enable = true;

      settings = {
        tools = {
          node = "18";
        };

        settings = {
          jobs = 16;
          verbose = true;
          asdf_compat = true;
          experimental = true;
        };
      };
    };

    #*********
    #* System
    #*********
    security = {
      gpg = enabled;
    };

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
            hostname = "82.165.211.45";
          };

          "builder-root" = {
            user = "root";
            hostname = "82.165.211.45";
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
      ];
    };
  };
}
