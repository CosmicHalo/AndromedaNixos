return {
	"AstroNvim/astrocore",
	opts = {
		mappings = {
			n = {
				-- ##############
				-- BUFFER
				-- ##############
				["<leader>b"] = { desc = "Buffers" },
				L = {
					function()
						require("astrocore.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
					end,
					desc = "Next buffer",
				},
				H = {
					function()
						require("astrocore.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
					end,
					desc = "Previous buffer",
				},
				["<leader>bD"] = {
					function()
						require("astroui.status.heirline").buffer_picker(function(bufnr)
							require("astrocore.buffer").close(bufnr)
						end)
					end,
					desc = "Pick to close",
				},

				-- ############
				-- MISC
				-- ############
				["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
				["<C-q>"] = { ":q!<cr>", desc = "Quit File" }, -- change description but the same command
			},
			t = {},
		},
	},
}
