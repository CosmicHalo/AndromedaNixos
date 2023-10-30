{lib, ...}: let
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
in
  with lib.milkyway; {
    config = {
      plugins.telescope = {
        enable = true;

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
          ["<C-p>" "git_files" "Telescope Git Files"]

          ["<leader>f<cr>" "resume" "Resume previous search"]
          ["<leader>fF" ''find_files { hidden = true, no_ignore = true }'' "Find all Files"]

          ["<leader>fw" ''live_grep'' "Find Words"]
          [
            "<leader>fW"
            ''
              require("telescope.builtin").live_grep {
                additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
              }
            ''
            "Find All Words"
          ]

          ["<leader>fb" ''buffers'' "Find Buffers"]
          ["<leader>fc" ''grep_string'' "Find word under Cursor"]
          ["<leader>fC" ''commands'' "Find Commands"]
          ["<leader>fk" ''keymaps'' "Find keymaps"]
          ["<leader>ft" ''colorscheme { enable_preview = true }'' "Find themes"]
          ["<leader>fn" ''colorscheme { enable_preview = true }'' "Find themes"]
          ["<leader>gb" ''git_branches'' "Git branches"]
          ["<leader>gc" ''git_commits'' "Git commits"]
          ["<leader>gt" ''git_status'' "Git status"]
          ["<leader>lD" ''diagnostics'' "Search diagnostics"]
          ["<leader>ls" ''lsp_document_symbols'' "Search symbols"]
        ];

        extensions = {
          file_browser = {
            enable = true;
            hidden = true;
            cwdToPath = true;
          };

          fzf-native = {
            enable = true;
            fuzzy = true;
          };

          undo = {
            enable = true;
            useDelta = true;
            sideBySide = true;
          };
        };

        extraOptions = {
          pickers.colorscheme.enable_preview = true;
        };
      };

      # keymaps = vim.mkLuaNKeymaps [
      #   ["<leader>fn" ''function() require("telescope").extensions.notify.notify() end'' "Find notfications"]
      #   ["<leader>fp" ''<cmd>Telescope projects<cr>'' "Find projects"]
      # ];
    };
  }
