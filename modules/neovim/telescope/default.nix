{helpers, ...}: let
  mkTelescopeKeymap = binding: action: desc: {
    "${binding}" = {
      inherit action desc;
    };
  };

  mkTelescopeKeymaps = bindings:
    builtins.foldl' (acc: binding: let
      bindings =
        builtins.foldl' (f: f)
        mkTelescopeKeymap
        binding;
    in
      acc // bindings)
    {}
    bindings;
in {
  config = {
    plugins.telescope = {
      enable = true;

      extraOptions = {
        pickers.colorscheme.enable_preview = true;
      };

      # extensions.frecency.enable = true;
      # extensions.project-nvim.enable = true;

      defaults = {
        prompt_prefix = " ";
        selection_caret = "❯ ";
        sorting_strategy = "ascending";

        path_display = [
          "truncate"
        ];

        layout_config = {
          width = 0.87;
          height = 0.80;
          preview_cutoff = 120;

          horizontal = {
            prompt_position = "top";
            preview_width = 0.55;
          };

          vertical = {
            mirror = false;
          };
        };
      };

      keymaps = mkTelescopeKeymaps [
        ["<leader>fg" "live_grep" "Live grep"]
        # ["<C-p>" "git_files" "Telescope Git Files"]

        # ["<leader>f<cr>" "resume" "Resume previous search"]
        ["<leader>fF" ''find_files { hidden = true, no_ignore = true }'' "Find all Files"]
      ];

      # keymaps = {
      #   "<leader>fF" = {
      #     action = "find_files { hidden = true, no_ignore = true }";
      #     desc = "Find all Files";
      #   };
      # };
    };

    maps.normal = {
      # "<leader>fF" = {
      #   action = ''function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end'';
      #   lua = true;
      #   silent = true;
      #   desc = "Find all Files";
      # };
      "<leader>fw" = {
        action = ''function() require("telescope.builtin").live_grep() end'';
        lua = true;
        silent = true;
        desc = "Find Words";
      };
      "<leader>fW" = {
        action = ''
          function()
            require("telescope.builtin").live_grep {
              additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
            }
          end
        '';
        lua = true;
        silent = true;
        desc = "Find Words";
      };
      "<leader>fb" = {
        action = ''function() require("telescope.builtin").buffers() end'';
        lua = true;
        silent = true;
        desc = "Find Buffers";
      };
      "<leader>fc" = {
        action = ''function() require("telescope.builtin").grep_string() end'';
        lua = true;
        silent = true;
        desc = "Find word under Cursor";
      };
      "<leader>fC" = {
        action = ''function() require("telescope.builtin").commands() end'';
        lua = true;
        silent = true;
        desc = "Find Commands";
      };
      "<leader>fk" = {
        action = ''function() require("telescope.builtin").keymaps() end'';
        lua = true;
        silent = true;
        desc = "Find keymaps";
      };
      "<leader>ft" = {
        action = ''function() require("telescope.builtin").colorscheme { enable_preview = true } end'';
        lua = true;
        silent = true;
        desc = "Find themes";
      };
      "<leader>fn" = {
        action = ''function() require("telescope").extensions.notify.notify() end'';
        lua = true;
        silent = true;
        desc = "Find notfications";
      };
      # "<leader>fp" = {
      #   action = "<cmd>Telescope projects<cr>";
      #   silent = true;
      #   desc = "Find projects";
      # };
      "<leader>gb" = {
        action = ''function() require("telescope.builtin").git_branches() end'';
        lua = true;
        silent = true;
        desc = "Git branches";
      };
      "<leader>gc" = {
        action = ''function() require("telescope.builtin").git_commits() end'';
        lua = true;
        silent = true;
        desc = "Git commits";
      };
      "<leader>gt" = {
        action = ''function() require("telescope.builtin").git_status() end'';
        lua = true;
        silent = true;
        desc = "Git status";
      };
      "<leader>lD" = {
        action = ''function() require("telescope.builtin").diagnostics() end'';
        lua = true;
        silent = true;
        desc = "Search diagnostics";
      };
      "<leader>ls" = {
        action = ''function() require("telescope.builtin").lsp_document_symbols() end'';
        lua = true;
        silent = true;
        desc = "Search symbols";
      };
    };

    colorschemes.catppuccin.customHighlights = {
      TelescopeBorder = {
        fg = helpers.mkRaw "colors.mantle";
        bg = helpers.mkRaw "colors.crust";
      };
      TelescopeNormal = {
        bg = helpers.mkRaw "colors.crust";
      };
      TelescopePreviewBorder = {
        fg = helpers.mkRaw "colors.crust";
        bg = helpers.mkRaw "colors.crust";
      };
      TelescopePreviewNormal = {
        bg = helpers.mkRaw "colors.crust";
      };
      TelescopePreviewTitle = {
        fg = helpers.mkRaw "colors.crust";
        bg = helpers.mkRaw "colors.green";
      };
      TelescopePromptBorder = {
        fg = helpers.mkRaw "colors.mantle";
        bg = helpers.mkRaw "colors.mantle";
      };
      TelescopePromptNormal = {
        fg = helpers.mkRaw "colors.text";
        bg = helpers.mkRaw "colors.mantle";
      };
      TelescopePromptPrefix = {
        fg = helpers.mkRaw "colors.red";
        bg = helpers.mkRaw "colors.mantle";
      };
      TelescopePromptTitle = {
        fg = helpers.mkRaw "colors.crust";
        bg = helpers.mkRaw "colors.red";
      };
      TelescopeResultsBorder = {
        fg = helpers.mkRaw "colors.crust";
        bg = helpers.mkRaw "colors.crust";
      };
      TelescopeResultsNormal = {
        bg = helpers.mkRaw "colors.crust";
      };
      TelescopeResultsTitle = {
        fg = helpers.mkRaw "colors.crust";
        bg = helpers.mkRaw "colors.crust";
      };
    };
  };
}
