local M = {}

M.debug = function (...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

M.stdpath = function (type)
  return vim.fn.stdpath(type)
end

M.augroup = function (definitions)
	for group_name, definition in pairs(definitions) do
		core.cmd('augroup '..group_name)
		core.cmd('autocmd!')
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
			core.api.cmd(command)
		end
		core.cmd('augroup END')
	end
end

M.tbl_concat = function (tbl1, tbl2)
	for k, v in ipairs(tbl1) do
		tbl2[k] = v
	end
end

return M
