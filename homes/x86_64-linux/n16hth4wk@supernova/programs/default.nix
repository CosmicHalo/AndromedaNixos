_: {
  imports = [
    ./zsh.nix
  ];

  milkyway.apps.neovim = {
    enable = true;

    lazycfg = {
      spec = ''
        { "AstroNvim/AstroNvim", branch = "v4", version = USE_STABLE and "^4" or nil, import = "astronvim.plugins" },

        -- pin plugins to known working versions
        { import = "astronvim.lazy_snapshot", cond = USE_STABLE },

        -- import/override with your plugins
        { import = "plugins" },
      '';
    };

    astronvim = {
      enable = true;

      astroui = {
        colorscheme = "catppuccino";
      };

      astrocore = {};

      astrolsp = {
        diagnostics = {
          underline = true;
          virtual_text = true;
        };

        formatting = {
          timeout_ms = 1000;
          format_on_save = {
            enabled = true;
            allow_filetypes = [];
            ignore_filetypes = [];
          };
        };

        servers = ["pyright"];

        mappings = {
          n = {
            gl = {
              desc = "Hover diagnostics";
              action = ''function() vim.diagnostic.open_float() end'';
            };
          };
        };
      };
    };
  };
}
