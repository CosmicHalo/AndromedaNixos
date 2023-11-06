return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				sandwich = false,
				noice = true,
				mini = true,
				leap = true,
				markdown = true,
				neotest = true,
				cmp = true,
				overseer = true,
				lsp_trouble = true,
				rainbow_delimiters = true,
			},
		},
	},

	{
		"AstroNvim/astroui",
		opts = {
			colorscheme = "catppuccin", -- change colorscheme
		},
	},
}
