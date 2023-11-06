{lib, ...}:
with lib.galaxy; {
  imports = [
    ./zsh.nix
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  galaxy = {
    /*
     *******
    * user *
    *******
    */
    user = enabled;

    /*
     ******
    * nix *
    ******
    */
    nix = {
      home-manager = enabled;
      tools = {
        alejandra = enabled;
        cachix = enabled;
        deadnix = enabled;
        direnv = enabled;
        statix = enabled;
      };
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
