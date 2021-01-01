if exists('g:loaded_plugins') | finish | endif

command! PluginsInstall lua require"plugins".install()
command! PluginsUpdate lua require"plugins".update()
command! PluginsRemove -nargs=* lua require"plugins".remove(<args>)

let g:loaded_plugins = 1
