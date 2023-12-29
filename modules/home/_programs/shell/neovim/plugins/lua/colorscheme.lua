return {
	-- oxocarbon
	{ "nyoom-engineering/oxocarbon.nvim", lazy = true },

	-- starry
	{ "ray-x/starry.nvim", lazy = true },

	-- onedarkpro
	{
		"olimorris/onedarkpro.nvim",
		opts = {
			options = {
				highlight_inactive_windows = true,
			},
		},
	},

	-- Terafox
	-- Nordfox
	-- Duskfox
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		opts = {
			options = {
				module_default = false,
				modules = {
					aerial = true,
					cmp = true,
					["dap-ui"] = true,
					dashboard = true,
					diagnostic = true,
					gitsigns = true,
					native_lsp = true,
					neotree = true,
					notify = true,
					symbol_outline = true,
					telescope = true,
					treesitter = true,
					whichkey = true,
				},
			},
			groups = { all = { NormalFloat = { link = "Normal" } } },
		},
	},

	-- tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = { style = "moon" },
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				cmp = true,
				mini = true,
				alpha = true,
				mason = true,
				noice = true,
				flash = false,
				notify = true,
				neotest = true,
				neotree = true,
				gitsigns = true,
				telescope = true,
				which_key = true,
				illuminate = true,
				treesitter = true,
				lsp_trouble = true,
				semantic_tokens = true,
				indent_blankline = { enabled = true },
				navic = { enabled = true, custom_bg = "lualine" },
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
			},
		},
	},

	{
		"AstroNvim/astroui",
		opts = {
			colorscheme = "nordfox", -- change colorscheme
		},
	},
}
