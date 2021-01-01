local core = require 'core'
local utils = require 'utils'
local uv = vim.loop

local plugins = {}
local path = utils.path('data') .. '/site/pack/plugins/'

local sources = {
  github = 'https://github.com/'
}

local regexes = {
  repo = '[%w-]+/([%w-_.]+)$'
}

local function msg (message, success, context)
	local status_show = success and 'Plugin [OK]: ' or 'Plugin [ERROR]: '

	print (status_show .. message .. ' ' .. tostring(context))
end

local function msg (action, args, success)
  local status_show = success and 'Plugin: ' or 'Plugin: Failed to '

  print (status_show .. action .. ' ' .. vim.inspect(args))
end

local function exec_hook (hook, name, dir)
  local t = type(hook)

  if t ~= 'function' then msg ('Hook', name, nil) end

  core.cmd('packloadall!')

  local result = pcall(hook)

  msg ('Hook execution', result, {name = name, dir = dir})
end

local function exec_cmd (cmd, name, dir, action, cmd_args, hook)
  local handle
	handle = uv.spawn(cmd, {args=cmd_args, cwd=(action ~= 'install' and dir or nil)},
    vim.schedule_wrap(function(...)
      local args={...}
			local success = args[0] == 0

			msg ('exec_cmd result', success, {cmd = cmd, args = cmd_args, name = name, dir = dir})

			if hook and success then exec_hook(hook, name, dir) end

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
        utils.debug('Attempting to install ' .. name .. ' to ' .. dir .. ' with URL ' .. args.url)
	exec_cmd ('/usr/bin/git', name, dir, 'install', install_args, args.hooks.install)
	end

end

local function remove (name, dir, is_installed, plugin_args)
	exec_cmd ('rm', name, dir, 'remove', {'-rf', plugin_dir(name)}, plugin_args.hooks.remove)
end

local function update (name, dir, isdir, args)
	if isdir then exec_cmd('git', name, dir, 'update', {'pull'}, args.hooks.update) end
end

local function plugin_dir (plugin)
  local opts = plugins[plugin]

  return path .. (opts.opt and 'opt' or 'start') .. '/' .. plugin
end

local function is_installed (plugin)
	local dir = plugin_dir(plugin)

	if core.fn.isdirectory(dir) ~= 0 then return true else return nil end
end

local function mapper (cb, name)
	local installed
	local plugin_feed = name and plugins[name] or plugins

	for plugin, args in pairs(plugin_feed) do
		installed = is_installed(plugin)
		cb(plugin, plugin_dir(plugin), installed, args)
	end
end

local function _plugins (args)
	if type(args) == "string" then args = {args} end

	local repo =	args[1]:match(regexes.repo)

	local _hooks = {
		init = function() end,
		install = function() end,
		update = function() end,
		remove = function() end
	}

	plugins[repo] = {
		branch = args.branch,
		loader = args.loader,
		hooks = args['hooks'] ~= nil and args.hooks or {},
		opt = args.opt,
		url = args.url or sources.github .. args[1] .. '.git',
	}

	for _type, func in pairs(_hooks) do if plugins[repo].hooks[_type] == nil then plugins[repo].hooks[_type] = func end end

	local deps = args.deps or {}

	for _, plugin in ipairs(deps) do _plugins (plugin) end
	plugins[repo].hooks.init(plugins[repo])
end

return {
	install = function () mapper(install) end,
	update = function () mapper(update) end,
	remove = function (name) mapper(remove, name) end,
	plugins = _plugins,
}
