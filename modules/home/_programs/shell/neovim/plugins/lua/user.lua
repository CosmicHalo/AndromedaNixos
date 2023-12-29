-- You can simply override any internal plugins using Lazy, here are some example operations:
return {
	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- Train your mind
	{ "tjdevries/train.nvim" },

	-- Discord Rich Presence
	{ "andweeb/presence.nvim", event = "VeryLazy", opts = { client_id = "1009122352916857003" } },

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		vscode = true,
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
}
