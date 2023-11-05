{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.milkyway.apps.neovim;

  coreImports = lib.andromeda.fs.get-nix-files ./core;
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

    xdg.configFile = {
      # Configurations
      "nvim/.luacheckrc".source = ./config/.luacheckrc;
      "nvim/.stylua.toml".source = ./config/.stylua.toml;
      "nvim/.neoconf.json".source = ./config/.neoconf.json;

      # Our bread and butter
      "nvim/init.lua".text = ''
        -- bootstrap lazy.nvim, AstroNvim, and user plugins
        require("config.lazy")

        -- run polish file at the very end
        pcall(require, "config.polish")
      '';
    };

    milkyway.apps.neovim = {
      plugins = {
        astrocore = {
          autocmds = {
            highlighturl = {
              desc = "URL Highlighting";
              event = ["VimEnter" "FileType" "BufEnter" "WinEnter"];
              callback = ''function() require("astrocore").set_url_match() end'';
            };
          };

          commands = {
            AstroReload = {
              desc = "Reload AstroNvim (Experimental)";
              action = ''function() require("astrocore").reload() end'';
            };
          };

          mappings = {
            n = [
              {
                key = "<C-s>";
                action = ":w!<cr>";
                desc = "Save File";
              }
              {
                key = "<C-q>";
                action = ":q!<cr>";
                desc = "quit File";
              }
            ];
          };

          on_keys = {
            auto_hlsearch = [
              ''
                function(char) -- example automatically disables `hlsearch` when not actively searching
                  if vim.fn.mode() == "n" then
                    local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
                    if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
                  end
                end,
              ''
            ];
          };
        };
      };
    };
  };
}
