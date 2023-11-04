-- AstroCore allows you easy access to customize the default options provided in AstroNvim
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- modify core features of AstroNvim
		features = {
			cmp = true, -- enable completion at start
			autopairs = true, -- enable autopairs at start
			highlighturl = true, -- highlight URLs at start
			notifications = true, -- enable notifications at start
			max_file = { size = 1024 * 100, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
		},
	},
}
