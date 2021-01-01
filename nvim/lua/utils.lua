local M = {};
local lspconfig = require 'lspconfig'

M.json = {
	encode = function (data) return M.cmd('json_encode ' .. data) end,
	decode = function (data) return M.cmd('json_decode ' .. data) end
}

M.debug = function (...) print(vim.inspect({...})) end

M.path = function (type)
  if type == "data" or type ~= nil then return vim.fn.stdpath('data') end
end

M.is_git = function () return lspconfig.util.root_pattern('.git') end

M.tbl_concat = function (tblin, tblto)
	for k, v in ipairs(tblin) do
		tblto[k] = v
	end
end

M.expand = function (str) return vim.fn.expand(str) end

M.require = function (pkg, force_reload)
  if package.loaded[pkg] and force_reload == true then package.loaded[pkg] = nil end

	return require (pkg)
end

M.ping = function() M.debug('PONG') end

return M
