local astronvim = require("astronvim")

return {
	{ "folke/neoconf.nvim", opts = {} },
	{
		"folke/neodev.nvim",
		opts = {
			override = function(root_dir, library)
				for _, astronvim_config in ipairs(astronvim.supported_configs) do
					if root_dir:match(astronvim_config) then
						library.plugins = true
						break
					end
				end
				vim.b.neodev_enabled = library.enabled
			end,
		},
	},

	-- LSP Signature
	-- {
	-- 	"ray-x/lsp_signature.nvim",
	-- 	event = "BufRead",
	-- 	opts = function()
	-- 		return { on_attach = require("astrolsp").on_attach }
	-- 	end,
	-- 	config = function()
	-- 		require("lsp_signature").setup({
	-- 			toggle_key = "M-t",
	-- 			select_signature_key = "M-n",

	-- 			bind = true, -- This is mandatory, otherwise border config won't get registered.
	-- 			handler_opts = {
	-- 				border = "rounded",
	-- 			},

	-- 			hint_inline = function()
	-- 				return false
	-- 			end,

	-- 			hint_enable = false, -- disable hints as it will crash in some terminal
	-- 		})
	-- 	end,
	-- },

	-- LSP inlayhints
	{
		"lvimuser/lsp-inlayhints.nvim",
		init = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
				callback = function(args)
					if not (args.data and args.data.client_id) then
						return
					end

					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.server_capabilities.inlayHintProvider then
						local inlayhints = require("lsp-inlayhints")
						inlayhints.on_attach(client, args.buf)
						require("astrocore").set_mappings({
							n = {
								["<leader>uH"] = { inlayhints.toggle, desc = "Toggle inlay hints" },
							},
						}, { buffer = args.buf })
					end
				end,
			})
		end,
		opts = {},
	},
}
