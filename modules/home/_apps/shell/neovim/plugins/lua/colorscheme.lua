return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				cmp = true,
				mini = true,
				leap = true,
				noice = true,
				neotest = true,
				markdown = true,
				illuminate = true,
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
