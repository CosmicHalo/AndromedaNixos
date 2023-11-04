{
  description = "A highly /nix/store/m380jmz5j05c3y3l2j05c97mmpbzbp6c-init.luaesome system configuration.";

  outputs = inputs @ {andromeda, ...}: let
    milkyway-lib = {
      inherit inputs;
      src = ./.;

      andromeda = {
        namespace = "milkyway";
        meta = {
          name = "milkyway";
          title = "MilkyWay Galaxy";
        };
      };
    };

    sources = import ./nix/sources.nix;
    specialArgs = {
      inherit sources;
      inherit (sources) my_ssh_keys gpg-base-conf;
    };
  in
    andromeda.lib.mkFlake (milkyway-lib
      // {
        channels-config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
          input-fonts.acceptLicense = true;
        };

        ###########
        # OVERLAYS
        ###########
        overlays = with inputs; [
          fenix.overlays.default
          chaotic.overlays.default
          devshell.overlays.default
          neovim-nightly-overlay.overlay
        ];

        ##########
        # SYSTEMS
        ##########
        systems = {
          inherit specialArgs;

          modules.nixos = with inputs; [
            chaotic.nixosModules.default
            vscode-server.nixosModules.default
            nix-index-database.nixosModules.nix-index
          ];
        };

        ##########
        # HOMES
        ##########
        # homes.users."n16hth4wk@supernova".modules = with inputs; [
        #   chaotic.homeManagerModules.default
        # ];

        ##########
        # ALIAS
        ##########
        alias = {
          shells.default = "milkyway-shell";
        };

        ##########
        # Outputs
        ##########
        outputs-builder = channels: {
          formatter = channels.nixpkgs.alejandra;

          checks.pre-commit-check = inputs.pre-commit-hooks.lib.${channels.nixpkgs.system}.run {
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
      });

  #**********
  #* CORE
  #**********
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Andromeda
    andromeda = {
      url = "git+file:///home/n16hth4wk/dev/nixos/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #**********
  #* NIX
  #**********
  inputs = {
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

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
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      # url = "github:nix-community/nixvim";
      url = "git+file:///home/n16hth4wk/dev/nixos/__libs__/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #*********
  #* MISC
  #*********

  inputs = {
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.flake-utils.follows = "flake-utils";
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
