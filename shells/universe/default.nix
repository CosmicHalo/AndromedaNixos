{
  pkgs,
  inputs,
  system,
  ...
}:
pkgs.devshell.mkShell {
  devshell.name = "universe";
  devshell.motd = ''$(type -p menu &>/dev/null && menu)'';
  devshell.startup.preCommitHooks.text = inputs.self.checks.${system}.pre-commit-check.shellHook;

  commands = [
    {package = "nix-melt";}
    {package = "pre-commit";}
  ];
}
