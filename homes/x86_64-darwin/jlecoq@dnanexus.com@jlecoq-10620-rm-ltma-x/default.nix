{
  lib,
  pkgs,
  ...
}:
with lib.milkyway; {
  imports = [
    ./shared/zsh.nix
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
    programs = {
      aws-cli = enabled;
      go-task = enabled;
      zoxide = enabled;
    };

    development = {
      ocaml = enabled;
      nodejs = {
        enable = true;
        rush = enabled;
      };
    };

    tools = {
      git = {
        enable = true;
        signingKey = "C505 1E8B 06AC 1776 6875  1B60 93AF DAD0 10B3 CB8D";
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
      ssh = {
        enable = true;
        ssh-agent = disabled;

        matchBlocks = {
          "home" = {
            user = "n16hth4wk";
            hostname = "supernova";
          };

          "vdev" = {
            user = "jlecoq";
            hostname = "home.vdev.internal.dnanexus.com";
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

    #*********
    #* System
    #*********
    security = {
      gpg = enabled;
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
