{
  lib,
  config,
  ...
}: let
  cfg = config.milkyway.apps.neovim;
in
  lib.mkIf cfg.astronvim.enable {
    xdg.configFile = {
      # Our bread and butter
      "nvim/init.lua".text = ''
        -- bootstrap lazy.nvim; AstroNvim; and user plugins
        require("config.lazy")

        -- run polish file at the very end
        pcall(require, "config.polish")
      '';

      "nvim/.neoconf.json".text = ''
        {
          "neodev": {
            "library": {
              "enabled": true,
              "plugins": true
            }
          },
          "neoconf": {
            "plugins": {
              "lua_ls": {
                "enabled": true
              }
            }
          },
          "lspconfig": {
            "lua_ls": {
              "Lua.format.enable": false
            }
          }
        }
      '';

      "nvim/.luacheckrc".text = ''
        -- Global objects
        globals = {
          "vim",
          "bit",
        }

        -- Rerun tests only if their modification time changed
        cache = true

        -- Don't report unused self arguments of methods
        self = false

        ignore = {
          "631", -- max_line_length
          "212/_.*", -- unused argument, for vars with "_" prefix
        }
      '';

      "nvim/.stylua.toml".text = ''
        indent_width = 2
        column_width = 120
        line_endings = "Unix"
        indent_type = "Spaces"
        call_parentheses = "None"
        quote_style = "AutoPreferDouble"
        collapse_simple_statement = "Always"
      '';
    };
  }
