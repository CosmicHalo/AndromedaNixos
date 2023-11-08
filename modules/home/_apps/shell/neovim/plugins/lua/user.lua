-- You can simply override any internal plugins using Lazy, here are some example operations:
return {
	{ "AstroNvim/astrocommunity", branch = "v4" },

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
}
