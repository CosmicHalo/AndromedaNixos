local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.g.astronvim_first_install = true -- lets AstroNvim know that this is an initial installation
          	-- stylua: ignore
          	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Whether or not to use stable releases of AstroNvim
local USE_STABLE = false

require("lazy").setup({
	default = {
		lazy = "@lazy@",
	},
	spec = {
		-- TODO: remove branch v4 on release
		{ "AstroNvim/AstroNvim", branch = "v4", version = USE_STABLE and "^4" or nil, import = "astronvim.plugins" },
		-- pin plugins to known working versions
		{ import = "astronvim.lazy_snapshot", cond = USE_STABLE },

		-- import/override with your plugins
		{ import = "plugins.core" },
		{ import = "plugins" },
	},
	install = {
		missing = true,
		colorscheme = "@colorscheme@",
	},
	performance = {
		cache = {
			enabled = true,
		},
		checker = {
			enabled = true,
			notify = true,
		},
		rtp = {
			-- disable some rtp plugins, add more to your liking
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"zipPlugin",
			},
		},
	},
})
