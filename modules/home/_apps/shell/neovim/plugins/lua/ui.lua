local highlight = {
	"RainbowDelimiterRed",
	"RainbowDelimiterYellow",
	"RainbowDelimiterBlue",
	"RainbowDelimiterOrange",
	"RainbowDelimiterGreen",
	"RainbowDelimiterViolet",
	"RainbowDelimiterCyan",
}

return {
	-- * Blankline [https://github.com/HiPhish/rainbow-delimiters.nvim] * --
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = "User AstroFile",
		main = "rainbow-delimiters.setup",
		opts = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			return {
				highlight = highlight,
				-- strategy = {
				[""] = rainbow_delimiters.strategy["global"],
				vim = rainbow_delimiters.strategy["local"],
				-- },
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
			}
		end,
	},

	-- * Blankline [https://github.com/lukas-reineke/indent-blankline.nvim] * --

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "User AstroFile",
		main = "ibl",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")

			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			require("ibl").setup({
				indent = { char = "▏" },
				scope = { show_start = true, show_end = true, highlight = highlight },
				exclude = {
					buftypes = { "nofile", "terminal" },
					filetypes = {
						"help",
						"lazy",
						"alpha",
						"aerial",
						"Trouble",
						"startify",
						"NvimTree",
						"neo-tree",
						"dashboard",
						"neogitstatus",
					},
				},
			})

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end,
	},

	-- * VIM ILLUMINATE [https://github.com/RRethy/vim-illuminate] * --
	{
		"RRethy/vim-illuminate",
		event = "User AstroFile",
		opts = {},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},

	-- * scope nvim https://github.com/tiagovla/scope.nvim * --
	{ "tiagovla/scope.nvim", event = "VeryLazy", opts = {} },
	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		opts = function()
			require("telescope").load_extension("scope")
		end,
	},

	-- * Modes nvim https://github.com/mvllow/modes.nvim * --
	{ "mvllow/modes.nvim", version = "^0.2", event = "VeryLazy", opts = {} },
	{ "folke/which-key.nvim", optional = true, opts = { plugins = { presets = { operators = false } } } },
}
