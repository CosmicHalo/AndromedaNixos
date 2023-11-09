local prefix = "<leader>x"
local maps = { n = {} }
local icon = vim.g.icons_enabled and "󱍼 " or ""
maps.n[prefix] = { desc = icon .. "Trouble" }
require("astrocore").set_mappings(maps)

return {
	-- * scope nvim https://github.com/tiagovla/scope.nvim * --
	{ "tiagovla/scope.nvim", event = "VeryLazy", opts = {} },
	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		opts = function()
			require("telescope").load_extension("scope")
		end,
	},

	-- lsp symbol navigation for lualine. This shows where
	-- in the code structure you are - within functions, classes,
	-- etc - in the statusline.
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		init = function()
			vim.g.navic_silence = true
			require("utils.lsp").on_attach(function(client, buffer)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, buffer)
				end
			end)
		end,
		opts = function()
			return {
				separator = " ",
				highlight = true,
				depth_limit = 5,
			}
		end,
	},

	-- better vim.ui
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	-- TROUBLE
	{
		"AstroNvim/astrocore",
		opts = {
			mappings = {
				n = {
					[prefix .. "X"] = {
						"<cmd>TroubleToggle workspace_diagnostics<cr>",
						desc = "Workspace Diagnostics (Trouble)",
					},
					[prefix .. "x"] = {
						"<cmd>TroubleToggle document_diagnostics<cr>",
						desc = "Document Diagnostics (Trouble)",
					},
					[prefix .. "l"] = {
						"<cmd>TroubleToggle loclist<cr>",
						desc = "Location List (Trouble)",
					},
					[prefix .. "q"] = {
						"<cmd>TroubleToggle quickfix<cr>",
						desc = "Quickfix List (Trouble)",
					},
				},
			},
		},
	},

	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = {
			use_diagnostic_signs = true,
			action_keys = {
				close = { "q", "<esc>" },
				cancel = "<c-e>",
			},
			keys = {
				{
					"<leader>xx",
					"<cmd>TroubleToggle document_diagnostics<cr>",
					desc = "Document Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<cmd>TroubleToggle workspace_diagnostics<cr>",
					desc = "Workspace Diagnostics (Trouble)",
				},
				{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
				{ "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
				{
					"[q",
					function()
						if require("trouble").is_open() then
							require("trouble").previous({ skip_groups = true, jump = true })
						else
							local ok, err = pcall(vim.cmd.cprev)
							if not ok then
								vim.notify(err, vim.log.levels.ERROR)
							end
						end
					end,
					desc = "Previous trouble/quickfix item",
				},
				{
					"]q",
					function()
						if require("trouble").is_open() then
							require("trouble").next({ skip_groups = true, jump = true })
						else
							local ok, err = pcall(vim.cmd.cnext)
							if not ok then
								vim.notify(err, vim.log.levels.ERROR)
							end
						end
					end,
					desc = "Next trouble/quickfix item",
				},
			},
		},
	},
}
