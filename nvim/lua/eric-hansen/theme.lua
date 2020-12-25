local core = plugin('core')
local pkg = pkgs.pkg

pkg {'zefei/simple-dark', load = function() core.cmd('color simple-dark') end}
