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

    astronvim = {
      enable = mkEnableOption "Astronvim";
    };
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

    (mkIf cfg.astronvim.enable {
      xdg.configFile = {
        # Configurations
        "nvim/.luacheckrc".source = ./config/.luacheckrc;
        "nvim/.stylua.toml".source = ./config/.stylua.toml;
        "nvim/.neoconf.json".source = ./config/.neoconf.json;

        # Our bread and butter
        "nvim/init.lua".text = ''
          -- bootstrap lazy.nvim; AstroNvim; and user plugins
          require("config.lazy")

          -- run polish file at the very end
          pcall(require, "config.polish")
        '';
      };

      milkyway.apps.neovim = mkIf cfg.astronvim.enable {
        plugins = {
          astrocore = {
          };

          astroui = {
            colorscheme = "catppuccino";
          };

          astrolsp = {
            diagnostics = {
              underline = true;
              virtual_text = true;
            };

            formatting = {
              format_on_save = {
                enabled = true;
                allow_filetypes = [];
                ignore_filetypes = [];
              };
              timeout_ms = 1000;
            };

            servers = [
              "pyright"
            ];

            mappings = {
              n = {
                gl = {
                  action = ''function() vim.diagnostic.open_float() end'';
                  desc = "Hover diagnostics";
                };
              };
            };
          };
        };
      };
    })
  ];
}
