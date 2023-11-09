return {
	-- customize alpha options
	{
		"goolord/alpha-nvim",
		opts = function(_, opts)
			opts.section.header.val = {
				" █████  ███████ ████████ ██████   ██████",
				"██   ██ ██         ██    ██   ██ ██    ██",
				"███████ ███████    ██    ██████  ██    ██",
				"██   ██      ██    ██    ██   ██ ██    ██",
				"██   ██ ███████    ██    ██   ██  ██████",
				" ",
				"    ███    ██ ██    ██ ██ ███    ███",
				"    ████   ██ ██    ██ ██ ████  ████",
				"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
				"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
				"    ██   ████   ████   ██ ██      ██",
			}
			return opts
		end,
	},

	-- DIM UI
	{
		"zbirenbaum/neodim",
		event = "LspAttach",
		opts = {
			alpha = 0.85,
			blend_color = "#000000",
			update_in_insert = {
				enable = true,
				delay = 100,
			},
			hide = {
				virtual_text = true,
				signs = true,
				underline = true,
			},
		},
	},

	-- NeoScroll
	{ "karb94/neoscroll.nvim", event = "VeryLazy", opts = {} },
	-- animations
	{ "declancm/cinnamon.nvim", event = "VeryLazy", opts = {} },

	-- * VIM ILLUMINATE [https://github.com/RRethy/vim-illuminate] * --
	{
		"RRethy/vim-illuminate",
		event = "User AstroFile",
		opts = {},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},

	-- * Modes nvim https://github.com/mvllow/modes.nvim * --
	{ "mvllow/modes.nvim", version = "^0.2", event = "VeryLazy", opts = {} },
	{ "folke/which-key.nvim", optional = true, opts = { plugins = { presets = { operators = false } } } },

	-- * Blankline [https://github.com/HiPhish/rainbow-delimiters.nvim] * --
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = "User AstroFile",
		main = "rainbow-delimiters.setup",
		opts = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			return {
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
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

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = function(_, opts)
			local utils = require("astrocore")

			return utils.extend_tbl(opts, {
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					},
				},
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					lsp_doc_border = false, -- add a border to hover docs and signature help
					inc_rename = utils.is_available("inc-rename.nvim"), -- enables an input dialog for inc-rename.nvim
				},
			})
		end,
		init = function()
			vim.g.lsp_handlers_enabled = false
		end,
	},
}
