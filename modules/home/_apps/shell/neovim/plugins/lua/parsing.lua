-- Example customization of Treesitter
return {
	-- TREE-SITTER
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
				"lua",
				"nix",
			})
		end,
	},

	-- NONE-LS
	{
		"nvimtools/none-ls.nvim",
		opts = function(_, config)
			local null_ls = require("null-ls")

			if type(config.sources) == "table" then
				vim.list_extend(config.sources, {
					null_ls.builtins.diagnostics.deadnix,
					null_ls.builtins.code_actions.statix,
					null_ls.builtins.formatting.alejandra,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
				})
			end

			return config
		end,
	},
}
