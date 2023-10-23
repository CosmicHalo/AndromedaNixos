{
  description = "A highly awesome system configuration.";

  outputs = inputs @ {andromeda-lib, ...}: let
    snowfall = {
      namespace = "andromeda";
      meta = {
        name = "andromeda";
        title = "Andromeda Galaxy";
      };
    };
  in
    andromeda-lib.mkFlake {
      inherit inputs snowfall;
      src = ./.;

      channels-config = {
        allowUnfree = true;
        input-fonts.acceptLicense = true;
      };

      overlays = with inputs; [
        devshell.overlays.default
        neovim-nightly-overlay.overlay
      ];

      systems = {
        modules.nixos = with inputs; [
          # rust-overlay.overlays.default
          nix-index-database.nixosModules.nix-index
        ];
      };

      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;

        checks.pre-commit-check = inputs.pre-commit-hooks.lib.${channels.unstable.system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            deadnix.enable = true;
            gptcommit.enable = true;
            nil.enable = true;
            pre-commit-hook-ensure-sops.enable = true;
            prettier.enable = true;
            statix.enable = true;
            yamllint.enable = true;
          };
        };
      };
    };

  #**********
  #* CORE
  #**********
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Andromeda
    andromeda-lib = {
      url = "git+file:///home/n16hth4wk/dev/nixos/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #**********
  #* NIX
  #**********
  inputs = {
    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Have a local index of nixpkgs for fast launching of apps
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #*************************************
  #* FORMATTERS / LINTERS / LSP
  #*************************************
  inputs = {
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Easy linting of the flake
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        gitignore.follows = "gitignore";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };
  };

  #*********
  #* SHELL
  #*********
  inputs = {
    # Replacement for ls
    eza = {
      url = "github:eza-community/eza";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  #***********************
  #* DEVONLY INPUTS
  #***********************
  inputs = {
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Gitignore common input
    gitignore = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hercules-ci/gitignore.nix";
    };

    systems.url = "github:nix-systems/default";
  };
}
