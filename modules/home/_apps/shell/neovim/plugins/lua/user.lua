-- You can simply override any internal plugins using Lazy, here are some example operations:
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

	-- Train your mind
	{ "tjdevries/train.nvim" },
	-- Discord Rich Presence
	{ "andweeb/presence.nvim", event = "VeryLazy", opts = { client_id = "1009122352916857003" } },
}
