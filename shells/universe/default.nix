{
  pkgs,
  inputs,
  system,
  ...
}: let
  rootDir = "$PRJ_ROOT";
in
  pkgs.devshell.mkShell {
    devshell.name = "universe";
    devshell.motd = ''$(type -p menu &>/dev/null && menu)'';
    devshell.startup.preCommitHooks.text = inputs.self.checks.${system}.pre-commit-check.shellHook;

    packages = with pkgs; [
      alejandra
      fd
    ];

    commands = [
      {package = "nix-melt";}
      {package = "pre-commit";}

      {
        command = "git rm --ignore-unmatch -f ${rootDir}/{tests,examples}/*/flake.lock";
        help = "Remove all lock files";
        name = "rm-locks";
      }
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

      # Nixos
      {
        category = "build";
        name = "build-nixos";
        command = "nixos-rebuild build --flake ${rootDir}#supernova --fast --show-trace";
      }
      {
        category = "dry-build";
        name = "build-nixos-dry";
        command = "nixos-rebuild dry-build --flake ${rootDir}#supernova --fast --show-trace";
      }

      # Home-manager
    ];
  }
