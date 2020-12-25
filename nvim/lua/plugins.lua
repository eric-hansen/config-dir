local core = require 'core'
local utils = require 'utils'

local plugins = {}
local path = utils.path('data') .. '/site/pack/plugins'

local sources = {
  github = 'https://github.com'
}

local regexes = {
  repo = '[%w-]+/([%w-_.]+)$'
}

local function msg (action, args, success)
  local status_show = success and 'Plugin: ' or 'Plugin: Failed to '

  print (status_show .. action .. ' ' .. args)
end

local function exec_hook (hook, name, dir)
  local t = type(hook)

  if t ~= 'function' then msg ('Hook', name, nil) end

  core.cmd('packloadall!')

  local result = pcall(hook)

  msg ('Hook', name, result)
end

local function exec_cmd (cmd, name, dir, action, args, hook)
  local handle
	handle = core.uv.spawn(cmd, {args=args, cwd={action ~= 'install' and dir or nil}},
    vim.schedule_wrap(function(code)
      msg (action, name, code == 0)
      if hook then exec_hook(hook, name, dir) end
      handle:close()
    end)
  )
end

local function install (name, dir, isdir, args)
	local install_args

	if not isdir then
		if args.branch then
			install_args = {'clone', args.url, '-b', args.branch, '--single-branch', dir}
		else
			install_args = {'clone', args.url, dir}
		end
	end

	exec_cmd ('git', name, dir, 'install', install_args, args.hooks.install)
end

local function update (name, dir, isdir, args)
	if isdir then exec_cmd('git', name, dir, 'update', {'pull'}, args.hooks.update) end
end

local function is_installed (plugin)
	local opts = plugins[plugin]
	local dir = path .. (opts.opt and 'opt' or 'start') .. '/' .. plugin

	if core.fn.isdirectory(dir) ~= 0 then return dir else return nil end
end

local function mapper (cb)
	local dir

	for plugin, args in pairs(plugins) do
		dir = is_installed(plugin)
		cb(plugin, dir, dir ~= 0, args)
	end
end

local function _plugins (args)
	if type(args) ~= "string" then args = {args} end

	local repo =	args[1]:match(regexes.repo)

	plugins[repo] = {
		branch = args.branch,
		loader = args.loader,
		hooks = args.hooks or {},
		opt = args.opt,
		url = args.url or sources.github .. args[1] .. '.git',
	}

	if is_installed(repo) then args.hooks.init(plugins[repo]) end
end

return {
	install = function () mapper(install) end,
	update = function () mapper(update) end,
	__call = _plugins,
}
