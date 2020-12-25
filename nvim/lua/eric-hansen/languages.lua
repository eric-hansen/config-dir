-- Programming languages support, this needs to be loaded before any language-specific stuff like PHP

pkg {'neovim/nvim-lspconfig', load=function() core.cmd('packadd nvim-lspconfig') end}

plugin('php', 'eric-hansen')
plugin('lua', 'eric-hansen')

--return {
--  lsp = plugin('nvim_lsp', '', {force=nil})
--}
