local pkg = pkgs.pkg
local core = plugin('core')

pkg {'junegunn/fzf', install = function() core.call('fzf#install') end}
pkg {'junegunn/fzf.vim'}
