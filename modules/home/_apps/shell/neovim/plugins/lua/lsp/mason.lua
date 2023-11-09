return {
	-- MASON
	{
		-- use mason-lspconfig to configure LSP installations
		{
			"williamboman/mason-lspconfig.nvim",
			opts = function(_, opts)
				-- add more things to the ensure_installed table protecting against community packs modifying it
				opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
					"lua_ls",
					"nil_ls",
				})
			end,
		},
		-- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
		{
			"jay-babu/mason-null-ls.nvim",
			opts = function(_, opts)
				opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
					"prettier",
					"stylua",
				})
			end,
		},
		{
			"jay-babu/mason-nvim-dap.nvim",
			opts = function(_, opts)
				opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
					-- "python",
				})
			end,
		},
	},

	-- NONE-LS
	{
		"nvimtools/none-ls.nvim",
		dependencies = { { "AstroNvim/astrolsp", opts = {} } },
		opts = function(_, config)
			local null_ls = require("null-ls")

			if type(config.sources) == "table" then
				vim.list_extend(config.sources, {
					-- MISC
					null_ls.builtins.formatting.prettierd,

					-- NIX
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.deadnix,
					null_ls.builtins.code_actions.statix,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.alejandra,

					-- LUA
					null_ls.builtins.formatting.stylua,
				})
			end

			config.on_attach = require("astrolsp").on_attach

			return config
		end,
	},
}
