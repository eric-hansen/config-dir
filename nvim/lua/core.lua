local M = {
	debug_enabled = 1
};

M.api = vim.api
M.uv = vim.loop
M.fn = vim.fn
M.cmd = vim.cmd
M.g = vim.g
M.o = vim.o

M.keymap = {
}

setmetatable(M.keymap, {
	__call = function (mode, map, exec, opts)
		M.api.nvim_set_keymap(mode, map, exec, opts)
	end
})

return M;
