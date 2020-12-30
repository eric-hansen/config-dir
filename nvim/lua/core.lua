local M = {
	debug_enabled = 1
};

local utils = require 'utils'

M.api = vim.api
M.uv = vim.loop
M.fn = vim.fn
M.cmd = vim.cmd
M.g = vim.g
M.o = vim.o

M.keymap = {
}

setmetatable(M.keymap, {
	__call = function (_, mode, map, exec, opts)
		local default_opts = {
			noremap = true,
			silent = true
		}

		utils.tbl_concat(opts or {}, default_opts)

		M.api.nvim_set_keymap(mode, map, exec, default_opts)
	end
})

M.theme = function (plugins, theme_name, alias)
	local regex = '[%w-]+/([%w-_.]+)$'
	local userrepo_parse = theme_name:match(regex)
	local color_name = userrepo_parse and userrepo_parse[1] or alias

	local init_theme = function()
		M.cmd('color ' .. color_name)
		M.cmd 'syntax on'
	end

	plugins {theme_name, hooks = {
			init = init_theme,
			install = init_theme
		}
	}
end

return M;
