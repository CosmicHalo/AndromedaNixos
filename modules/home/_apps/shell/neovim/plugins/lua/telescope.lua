return {
	{
		"AstroNvim/astrocore",
		opts = {
			mappings = {
				n = {
					["<leader>fu"] = { "<cmd>Telescope undo<CR>", desc = "Find undos" },
				},
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
		},
		opts = function()
			require("telescope").load_extension("undo")
		end,
	},
}
