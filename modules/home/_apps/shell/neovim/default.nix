{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.milkyway; let
  cfg = config.milkyway.apps.neovim;
in {
  options.milkyway.apps.neovim = {
    enable = mkEnableOption "Neovim";
    neovide = mkEnableOpt "Neovide";
    astronvim = mkEnableOpt "Astronvim";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # Use Neovim for Git diffs.
      programs = {
        zsh.shellAliases.vimdiff = "nvim -d";
        bash.shellAliases.vimdiff = "nvim -d";
      };

      home = {
        packages = with pkgs;
          [
            vim
            neovim

            # Needed for neovim
            gcc
            gnumake
            unzip

            luajit
            luajitPackages.stdlib
            luajitPackages.inspect
            luajitPackages.luacheck
            luajitPackages.luarocks-nix
          ]
          ++ lib.optional cfg.neovide.enable neovide;

        sessionVariables = {
          EDITOR = "nvim";
        };

        shellAliases = {
          vimdiff = "nvim -d";
        };
      };
    })
  ];
}
