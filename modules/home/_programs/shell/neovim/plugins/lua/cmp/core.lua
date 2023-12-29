return {
	-- Use <tab> for completion and snippets (supertab)
	-- first: disable default <tab> and <s-tab> behavior in LuaSnip
	{
		"L3MON4D3/LuaSnip",
		keys = function()
			return {}
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"AstroNvim/astrocore",
				opts = function(_, opts)
					local maps = opts.mappings
					maps.n["<Leader>uc"] = {
						function()
							require("astrocore.toggles").buffer_cmp()
						end,
						desc = "Toggle autocompletion (buffer)",
					}
					maps.n["<Leader>uC"] = {
						function()
							require("astrocore.toggles").cmp()
						end,
						desc = "Toggle autocompletion (global)",
					}
				end,
			},

			"petertriho/cmp-git",
			"lukas-reineke/cmp-rg",
			"zbirenbaum/copilot-cmp",
			"chrisgrieser/cmp-nerdfont",
			"saadparwaiz1/cmp_luasnip",

			"hrsh7th/cmp-path",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		event = "InsertEnter",
	},

	{
		"hrsh7th/cmp-cmdline",
		dependencies = {
			"nvim-cmp",
		},
		event = { "CmdlineEnter" },
		opts = function()
			local cmp_mapping = require("cmp.config.mapping")
			local cmp_sources = require("cmp.config.sources")

			return {
				mapping = cmp_mapping.preset.cmdline(),
				sources = cmp_sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}, {
					{ name = "buffer" },
				}),
			}
		end,
		config = function(_, opts)
			require("cmp").setup.cmdline(":", opts)
		end,
	},
}
