return {
	{
		"AstroNvim/astrocore",
		opts = {
			mappings = {
				n = {
					["<leader>fu"] = { "<cmd>Telescope undo<CR>", desc = "Find undos" },
					["<leader>fz"] = { "<cmd>Telescope zoxide list<CR>", desc = "Find directories" },
				},
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"debugloop/telescope-undo.nvim",
				config = function()
					require("telescope").load_extension("undo")
				end,
			},
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
			{
				"jvgrootveld/telescope-zoxide",
				dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
				config = function()
					require("telescope").load_extension("zoxide")
				end,
			},
		},
		keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
		},
		-- change some options
		opts = {
			defaults = {
				winblend = 0,
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
			},
			extensions = {
				zoxide = {
					prompt_title = "[ Walking on the shoulders of TJ ]",
				},
			},
		},
	},
}
