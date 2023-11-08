return {
	{
		"RRethy/vim-illuminate",
		event = "User AstroFile",
		opts = {},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},

	{
		{ "tiagovla/scope.nvim", event = "VeryLazy", opts = {} },
		{
			"nvim-telescope/telescope.nvim",
			optional = true,
			opts = function()
				require("telescope").load_extension("scope")
			end,
		},
	},

	-- * Modes nvim https://github.com/mvllow/modes.nvim * --
	{ "mvllow/modes.nvim", version = "^0.2", event = "VeryLazy", opts = {} },
	{ "folke/which-key.nvim", optional = true, opts = { plugins = { presets = { operators = false } } } },
}
