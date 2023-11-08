{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.milkyway.apps.neovim;
in {
  options.milkyway.apps.neovim = {
    enable = mkEnableOption "Neovim";
    astronvim.enable = mkEnableOption "Astronvim";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # Use Neovim for Git diffs.
      programs = {
        zsh.shellAliases.vimdiff = "nvim -d";
        bash.shellAliases.vimdiff = "nvim -d";
      };

      home = {
        packages = with pkgs; [
          vim
          neovim

          # Needed for neovim
          gcc
          gnumake
          nodejs_18
          unzip

          lua54Packages.lua
          lua54Packages.inspect
          lua54Packages.luarocks

          #Rust
          toolchain
          rust-analyzer-nightly
        ];

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
