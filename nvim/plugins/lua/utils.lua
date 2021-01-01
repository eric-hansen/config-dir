local M = {};
local core = require 'core'

M.debug = function (...) if core.debug_enabled == 1 then print(vim.inspect({...})) end end

M.path = function (type)
  if type == "data" or type ~= nil then return core.fn.stdpath('data') end
end

M.tbl_concat = function (tblin, tblto) for k, v in ipairs(tblin) do tblto[k] = v end end

M.expand = function (str) return core.fn.expand(str) end

M.noop = function() return nil end

return M
