function plugin(plugin, leader, ...)
  local args = {...}

  -- Remove if necessary, maybe make a vim-var in init.vim to determine this?
  args.force = args.force or 1

  local leader = leader or 'eric-hansen'

  if leader and leader ~= '' then leader = leader .. '.' else leader = '' end

  local plugin_path = leader .. plugin

  if args.force then
    package.loaded[plugin_path] = nil
  end

  local result = require(plugin_path)

  return result
end

core = plugin('core')
pkgs = plugin('pkgs')
pkg = pkgs.pkg
plugin('theme')
plugin('fs')
plugin('keybindings')
plugin('languages')
plugin('mobility')

pkgs.install()
