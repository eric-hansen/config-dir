-- Heavily inspired by https://github.com/savq/paq-nvim/blob/master/lua/paq-nvim.lua

local utils = plugin('utils', 'eric-hansen')

local plugin_path = utils.stdpath('data') .. '/site/pack/pkgs'
local loop = vim.loop

local packages = {}

local get_dir = function (name, opt)
  return plugin_path .. '/' .. (opt and 'opt/' or 'start/') .. name
end

local is_dir = function (dir)
  return vim.fn.isdirectory(dir) ~= 0
end

local msg = function (ok, msg, action)
  utils.debug{status=(ok and 'SUCCESS' or 'FAILURE'), action = action, msg = msg}
end

-- Find a way to take in a callback and have that be called after handle:close()
local exec = function (action, name, args, opts)
  local handle
  handle = loop.spawn('git', {args=args}, vim.schedule_wrap(
    function (code, signal)
      msg(code == 0, 'Attempted calling git', action)
      handle:close()
      if opts.cb ~= nil then opts.cb() end
    end
    )
  )
end

local install = function (name, dir, args)
  -- utils.debug('Attempting to install or load ' .. name .. ' from ' .. dir)

  if not is_dir(dir) then
    local args = {
      'clone', args.url
    }

    if args.branch then table.insert(args, '-b'); table.insert(args, args.branch); table.insert('--single-branch'); end

    table.insert(args, dir)

    exec('install', name, args, {cb = packages[name].install})
  end

  packages[name].load()
end

local update = function (name, dir)
  if is_dir(dir) then
    exec('update', name, '-C', dir, 'pull')
    plugins[name].update()
  end
end

local map = function (fn)
  local dir

  for name, args in pairs(packages) do
    dir = get_dir(name, args.opt)
    fn(name, dir, args)
  end
end

local uninstall = function (dir, ispkgdir)
  local name, child
  local ok = true
  local handle = loop.fs_scandir(dir)
  while handle do
    name, t = loop.fs_scandir_next(handle)
    if not name then break end
    child = dir .. '/' .. name
    if ispkgdir then
      if not packages[name] then
        ok = uninstall(child)
        msg(ok, name, 'uninstall')
      end
    else
      ok = (t == 'directory') and uninstall(child) or loop.fs_unlink(child)
    end

    if not ok then return end
  end

  return ispkgdir or loop.fs_rmdir(dir)
end

local pkg = function(args)
  local t = type(args)

  if t == 'string' then args = {args} elseif t ~= 'table' then return end

  local repo_name = args[1]:match('^[%w-]+/([%w-_.]+)$')

  if not repo_name then
    msg(0, args[1], 'pkg rpeo name matcher')
    return
  end

  local nop = function() end

  packages[repo_name] = {
    branch = args.branch,
    opt = args.opt,
    url = args.url or 'https://www.github.com/' .. args[1] .. '.git',
    install = args.install or nop,
    update = args.update or nop,
    load = args.load or nop
  }
end

return {
  install = function() map(install) end,
  update = function() map(update) end,
  clean = function() uninstall(plugin_path .. '/start', 1); uninstall(plugin_path .. '/opt', 1); end,
  pkg = pkg,
  info = function() utils.debug(packages) end,
}
