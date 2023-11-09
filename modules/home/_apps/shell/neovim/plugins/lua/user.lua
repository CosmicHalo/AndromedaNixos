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
	},
}
