{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.milkyway.apps.neovim;

  coreImports = lib.andromeda.fs.get-default-nix-files ./core;
in {
  imports = coreImports;

  options.milkyway.apps.neovim = {
    enable = mkEnableOption "Neovim";
  };

  config = mkIf cfg.enable {
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
        luajitPackages.luarocks-nix
        nodejs_18
        unzip

        #Rust
        toolchain
        rust-analyzer-nightly
      ];

      sessionVariables = {
        PAGER = "bat";
        EDITOR = "nvim";
        MANPAGER = "bat";
      };

      shellAliases = {
        vimdiff = "nvim -d";
      };
    };

    xdg.configFile = {
      # Configurations
      "nvim/.luacheckrc".source = ./config/.luacheckrc;
      "nvim/.stylua.toml".source = ./config/.stylua.toml;
      "nvim/.neoconf.json".source = ./config/.neoconf.json;

      # Sources
      "nvim/lua".source = ./config/lua;

      # Our bread and butter
      "nvim/init.lua".text = ''
        -- bootstrap lazy.nvim, AstroNvim, and user plugins
        require("config.lazy")

        -- run polish file at the very end
        pcall(require, "config.polish")
      '';
    };
  };
}
