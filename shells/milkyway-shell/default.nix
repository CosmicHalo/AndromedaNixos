{
  pkgs,
  inputs,
  system,
  ...
}: let
  rootDir = "$PRJ_ROOT";
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

      # Nixos
      {
        name = "build-nix";
        category = "milkyway-build";
        help = "Build the current configuration";
        command = "nixos-rebuild build --fast --max-jobs auto";
      }
      {
        name = "test-nix";
        help = "Activate the current configuration";
        command = "sudo nixos-rebuild test --fast --max-jobs auto --cores 0";
      }
      {
        name = "switch-nix";
        category = "milkyway-switch";
        help = "Switch to the current configuration";
        command = "sudo nixos-rebuild switch --fast --max-jobs auto --cores 0";
      }

      # HM
      {
        name = "build-hm";
        category = "milkyway-build";
        help = "Build the current hm configuration";
        command = "home-manager build --max-jobs auto --cores 0";
      }
      {
        name = "switch-hm";
        category = "milkyway-switch";
        help = "Switch to the current hm configuration";
        command = "home-manager switch --max-jobs auto --cores 0";
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
