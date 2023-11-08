local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- lets AstroNvim know that this is an initial installation
	vim.g.astronvim_first_install = true
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Whether or not to use stable releases of AstroNvim
local USE_STABLE = false

require("lazy").setup({
	spec = { "@spec@" },
	default = { lazy = "@lazy@" },
	install = { missing = true, colorscheme = "@colorscheme@" },
	performance = {
		cache = { enabled = true },
		checker = { enabled = true, notify = true },
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
