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
        allowBroken = true;
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
        andromeda-tmux.overlays.default
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
        packages.default = "clear-hm";
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
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1.*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Andromeda
    andromeda = {
      url = "https://flakehub.com/f/milkyway-org/andromeda-lib/0.1.*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    andromeda-tmux = {
      url = "github:lecoqjacob/andromeda-tmux";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.andromeda.follows = "andromeda";
    };
  };

  #**********
  #* NIX
  #**********
  inputs = {
    chaotic = {
      url = "https://flakehub.com/f/chaotic-cx/nyx/0.1.*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Hardware Configuration
    nixos-hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/*.tar.gz";

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
      url = "https://flakehub.com/f/nix-community/fenix/*.tar.gz";
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
    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };

    my-ssh-keys = {
      url = "https://github.com/lecoqjacob.keys";
      flake = false;
    };

    sddm-catppuccin = {
      url = "github:khaneliman/sddm-catppuccin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.flake-utils.follows = "flake-utils";
    };

    zellij-forgot = {
      url = "https://github.com/karimould/zellij-forgot/releases/latest/download/zellij_forgot.wasm";
      flake = false;
    };

    zellij-room = {
      url = "https://github.com/rvcas/room/releases/latest/download/room.wasm";
      flake = false;
    };

    zellij-zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  ##########  HOMEBREW #########################################
  inputs = {
    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "darwin";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  #***************
  #* Colorscheme
  #***************

  inputs = {
    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
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

    flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/*.tar.gz";
    flake-compat = {
      url = "https://flakehub.com/f/edolstra/flake-compat/*.tar.gz";
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
