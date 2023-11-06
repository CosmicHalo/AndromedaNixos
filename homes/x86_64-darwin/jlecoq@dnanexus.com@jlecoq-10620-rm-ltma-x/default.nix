{lib, ...}:
with lib.lib.milkyway; {
  imports = [
    ./zsh.nix
  ];

  home.stateVersion = "23.11";
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  lib.milkyway = {
    user = enabled;
    fonts = enabled;

    #*********
    #* Suites
    #*********
    suites = {
      desktop = enabled;
      development = enabled;
      nix = enabled;
    };

    development = {
      nodejs = {
        enable = true;
        rush = enabled;
      };

      rtx = {
        enable = true;

        settings = {
          tools = {
            node = "18";
            python = ["2.7" "3.8" "3.11"];
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

    apps = {
      bitwarden = enabled;
      floorp = enabled;
    };

    shell = {
      aws = enabled;
      go-task = enabled;
      neovim = enabled;
      zoxide = enabled;

      git = {
        enable = true;
        signingKey = "C505 1E8B 06AC 1776 6875  1B60 93AF DAD0 10B3 CB8D";
      };
    };
  };
}
