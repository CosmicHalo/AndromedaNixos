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
