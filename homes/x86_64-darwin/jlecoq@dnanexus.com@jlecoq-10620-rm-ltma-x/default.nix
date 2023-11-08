{lib, ...}:
with lib.milkyway; {
  imports = [
    ./fonts.nix
    ./zsh.nix
  ];

  home.stateVersion = "23.11";
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  milkyway = {
    # *************
    #* System Config
    #***************

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
  };
}
