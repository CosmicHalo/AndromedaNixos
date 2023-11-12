{
  pkgs,
  inputs,
  system,
  ...
}: let
  rootDir = "$PRJ_ROOT";

  clean-nix = pkgs.writeShellScriptBin "clean-nix" ''
    repeat(){
      for i in {1..90}; do echo -n "$1"; done
      echo "\n"
    }

    title(){
      repeat "="
      echo -e "\n$1"
      repeat "="
    }

    title "[Clearing nix profile]"
    nix profile wipe-history

    title "[Clearing home-manager]"
    clear-hm

    title "[Clearing nix env]"
    nix-env --delete-generations old

    title "[Clearing nix store]"
    nix-store --gc --print-dead

    title "[Clearing nix cache]"
    sudo nix-collect-garbage -d
  '';
in
  pkgs.devshell.mkShell {
    devshell.name = "MilkyWay Shell";
    # devshell.motd = ''$(type -p menu &>/dev/null && menu)'';
    devshell.startup.preCommitHooks.text = inputs.self.checks.${system}.pre-commit-check.shellHook;

    packages = with pkgs; [
      milkyway.alejandra
      fd
    ];

    commands = [
      {package = "nix-melt";}
      {package = "pre-commit";}
      {
        name = "fmt";
        help = "Check Nix formatting";
        command = "nix fmt \${@} ${rootDir}";
      }
      {
        name = "evalnix";
        help = "Check Nix parsing";
        command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
      }

      # Milkyway
      {
        name = "clear-hm";
        category = "milkyway";
        help = "Clear home-manager";
        command = "${pkgs.milkyway.clear-hm}/bin/clear-hm";
      }
      {
        name = "clean-nix";
        category = "milkyway";
        help = "Compeltely clean nix";
        command = "${clean-nix}/bin/clean-nix";
      }

      #########
      # Nixos
      #########
      {
        name = "build-nix";
        category = "milkyway-build";
        help = "Build the current nixos configuration";
        command = "nixos-rebuild build --fast --max-jobs auto";
      }
      {
        name = "activate-nix";
        category = "milkyway-activate";
        help = "Activate the current nixos configuration";
        command = "sudo nixos-rebuild test --fast --max-jobs auto";
      }
      {
        name = "switch-nix";
        category = "milkyway-switch";
        help = "Switch to the current nixos configuration";
        command = "sudo nixos-rebuild switch --fast --max-jobs auto";
      }

      #########
      # Darwin
      #########
      {
        name = "build-darwin";
        category = "milkyway-build";
        help = "Build the current darwin configuration";
        command = "darwin-rebuild build --fast --max-jobs auto";
      }
      {
        name = "activate-darwin";
        category = "milkyway-activate";
        help = "Activate the current darwin configuration";
        command = "sudo darwin-rebuild activate --fast --max-jobs auto";
      }
      {
        name = "switch-darwin";
        category = "milkyway-switch";
        help = "Switch to the current darwin configuration";
        command = "sudo darwin-rebuild switch --fast --max-jobs auto";
      }

      ############
      # Home Manager
      ############
      {
        name = "build-hm";
        category = "milkyway-build";
        help = "Build the current hm configuration";
        command = "home-manager build --max-jobs auto";
      }
      {
        name = "activate-hm";
        category = "milkyway-activate";
        help = "Activate the current hm configuration";
        command = "home-manager activate --max-jobs auto";
      }
      {
        name = "switch-hm";
        category = "milkyway-switch";
        help = "Switch to the current hm configuration";
        command = "home-manager switch --max-jobs auto";
      }

      #########
      # Nixos
      #########

      #Build
      # {
      #   category = "build";
      #   name = "build-nixos";
      #   command = "nixos-rebuild build --flake ${rootDir}# --fast --show-trace --max-jobs 1";
      # }
      # {
      #   category = "build";
      #   name = "dry-build-nixos";
      #   command = "nixos-rebuild dry-build --flake ${rootDir}# --fast --show-trace";
      # }
      # #Activate
      # {
      #   category = "activate";
      #   name = "activate-nixos";
      #   command = "sudo nixos-rebuild test --flake ${rootDir}# --fast --show-trace --max-jobs 1";
      # }
      # {
      #   category = "activate";
      #   name = "dry-activate-nixos";
      #   command = "sudo nixos-rebuild dry-activate --flake ${rootDir}# --fast --show-trace";
      # }
      # #Switch
      # {
      #   category = "switch";
      #   name = "switch-nixos";
      #   command = "sudo nixos-rebuild switch --flake ${rootDir}# --fast --show-trace --max-jobs 1";
      # }
    ];
  }
