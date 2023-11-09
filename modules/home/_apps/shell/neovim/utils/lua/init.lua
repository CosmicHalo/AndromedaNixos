local M = {}

M.lsp = require("utils.lsp")

--- Get a plugin spec from lazy
---@param plugin string The plugin to search for
---@return LazyPlugin? available # The found plugin spec from Lazy
function M.get_plugin(plugin)
	local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
	return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
end

--- Resolve the options table for a given plugin with lazy
---@param plugin string The plugin to search for
---@return table opts # The plugin options
function M.plugin_opts(plugin)
	local spec = M.get_plugin(plugin)
	return spec and require("lazy.core.plugin").values(spec, "opts") or {}
end

--- Execute a function when a specified plugin is loaded with Lazy.nvim, or immediately if already loaded
---@param plugin string the name of the plugin to defer the function execution on
---@param func fun() the function to execute when the plugin is loaded
function M.on_load(plugin, func)
	local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
	if lazy_config_avail then
		if lazy_config.plugins[plugin] and lazy_config.plugins[plugin]._.loaded then
			vim.schedule(func)
		else
			local autocmd
			autocmd = vim.api.nvim_create_autocmd("User", {
				pattern = "LazyLoad",
				desc = ("A function to be ran when %s is loaded"):format(plugin),
				callback = function(args)
					if args.data == plugin then
						func()
						if autocmd then
							vim.api.nvim_del_autocmd(autocmd)
						end
					end
				end,
			})
		end
	end
end

return M
