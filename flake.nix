{
  description = "A highly /nix/store/m380jmz5j05c3y3l2j05c97mmpbzbp6c-init.luaesome system configuration.";

  outputs = inputs @ {
    self,
    andromeda,
    ...
  }: let
    specialArgs = {sources = import ./nix/sources.nix;};
  in
    andromeda.lib.mkFlake {
      inherit inputs;
      src = ./.;

      andromeda = {
        namespace = "milkyway";
        meta = {
          name = "milkyway";
          title = "MilkyWay Galaxy";
        };
      };

      channels-config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;

        allowUnfreePredicate = pkg:
          builtins.elem (self.lib.getName pkg) [
            "jetbrains-toolbox"
          ];

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

        modules.darwin = with inputs; [
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

      ##########
      # HOMES
      ##########
      homes = {inherit specialArgs;};

      ##########
      # ALIAS
      ##########
      alias = {
        shells.default = "milkyway-shell";
        packages.setup = "setup-env";
      };

      ##########
      # Outputs
      ##########
      outputs-builder = channels: {
        formatter = inputs.self.packages.${channels.nixpkgs.system}.alejandra;

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
    };

  #**********
  #* CORE
  #**********
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "git+file:///Users/jlecoq@dnanexus.com/dev/nix/__libs__/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Andromeda
    andromeda = {
      url = "git+file:///Users/jlecoq@dnanexus.com/dev/nix/lib";
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

  ##########  HOMEBREW #########################################
  inputs = {
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "darwin";
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
