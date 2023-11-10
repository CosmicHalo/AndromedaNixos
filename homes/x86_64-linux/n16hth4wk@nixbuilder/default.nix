{
  lib,
  pkgs,
  ...
}:
with lib.milkyway; {
  milkyway = {
    user = enabled;

    #*********
    #* Suites
    #*********
    suites = {
      nix = enabled;
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
      };
    };

    fonts = {
      enable = true;
      extraFonts = [
        # nerdfonts
        (pkgs.nerdfonts.override {
          fonts = [
            "FiraCode"
            "FiraMono"
            "Hack"
            "UbuntuMono"
          ];
        })
      ];
    };
  };
}
