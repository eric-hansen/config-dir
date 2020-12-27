local M = {};
local core = require 'core'
local lspconfig = require 'lspconfig'

M.debug = function (...) if core.debug_enabled == 1 then print(vim.inspect({...})) end end

M.path = function (type)
  if type == "data" or type ~= nil then return core.fn.stdpath('data') end
end

M.is_git = function () return lspconfig.util.root_pattern('.git') end

M.tbl_concat = function (tblin, tblto) for k, v in ipairs(tblin) do tblto[k] = v end end

M.expand = function (str) return core.fn.expand(str) end

return M
