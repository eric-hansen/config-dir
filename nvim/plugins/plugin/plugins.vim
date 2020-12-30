if exists('g:loaded_plugins') | finish | endif

command! PluginsInstall lua require"plugins".install()
command! PluginsUpdate lua require"plugins".update()

let g:loaded_plugins = 1
