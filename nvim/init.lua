core = require 'core'

core.g.mapleader = " "

utils = require 'utils'

core.cmd 'packadd plugins'

local sumneko_path = vim.fn.expand('$HOME/Projects/lua-language-server')

local plugin = utils.require('plugins', true).plugins

plugin {'liuchengxu/vim-which-key'}

plugin {'nvim-treesitter/nvim-treesitter'}
plugin {'neovim/nvim-lspconfig', hooks = {
	install = function()
		core.cmd('LspInstall tsserver<cr>')
		core.cmd('LspInstall sumneko<cr>')
	end,
	init = function()
		core.keymap('n', '<leader>lh',  ':lua vim.lsp.buf.hover()<cr>')
		core.keymap('n', '<leader>lde', ':lua vim.lsp.buf.definition()<cr>')
		core.keymap('n', '<leader>li',  ':lua vim.lsp.buf.implementation()<cr>')
		core.keymap('n', '<leader>lsh', ':lua vim.lsp.buf.signature_help()<cr>')
		core.keymap('n', '<leader>lsd', ':lua vim.lsp.buf.document_symbol()<cr>')
		core.keymap('n', '<leader>lsw', ':lua vim.lsp.buf.workspace_symbol()<cr>')
		core.keymap('n', '<leader>ltd', ':lua vim.lsp.buf.type_definition()<cr>')
		core.keymap('n', '<leader>lr',  ':lua vim.lsp.buf.references()<cr>')
		core.keymap('n', '<leader>lR',  ':lua vim.lsp.buf.rename()<cr>')

--		core.cmd 'set omnifunc=v:lua.vim.lsp.omnifunc'
	end
}}
plugin {'junegunn/fzf', hooks = { install = core.fn['fzf#install']}}
plugin {'junegunn/fzf.vim', hooks = {
	init = function()
		core.api.nvim_set_keymap('n', '<leader>f', ':Files<cr>', { noremap = true, silent = true })
		core.api.nvim_set_keymap('n', '<leader>lb', ':Buffers<cr>', { noremap = true, silent = true })
	end
}}
plugin {'ojroques/nvim-lspfuzzy'}
plugin {'nvim-lua/completion-nvim'}
plugin {'numtostr/FTerm.nvim', hooks = {
	init = function()
		core.api.nvim_set_keymap('n', '<A-i>', '<CMD>lua require"FTerm".toggle()<cr>', { noremap = true, silent = true})
		core.api.nvim_set_keymap('t', '<A-i>', '<C-\\><C-n><CMD>lua require"FTerm".toggle()<cr>', { noremap = true, silent = true})
	end
}}

plugin {'nvim-lua/lsp-status.nvim', hooks = {
	init = function()

	end
}}

--core.theme(paq, 'zefei/simple-dark')
core.theme(plugin, 'sts10/vim-pink-moon', 'pink-moon')

plugin {'liuchengxu/vista.vim', hooks = {
	init = function ()
		core.g.vista_default_executive = 'nvim_lsp' -- neovim-lspconfig
		core.keymap('n', '<leader>tb', ':Vista!!<cr>')
	end
	}
}

local ts = require 'nvim-treesitter.configs'
ts.setup {highlight = {enable = true}}

local lsp = require 'lspconfig'
local on_attach = function()
	require 'completion'.on_attach()
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = true
	}
)

local lspfuzzy = require 'lspfuzzy'

lsp.bashls.setup {}

lsp.intelephense.setup {
	on_attach = on_attach,
	cmd = {"/usr/local/bin/intelephense", "--stdio"}
}

lsp.jsonls.setup {}

lsp.sumneko_lua.setup {
	on_attach = on_attach,
  cmd = {sumneko_path .. "/bin/Linux/lua-language-server", "-E", sumneko_path .. "/main.lua"};
  settings = {
	  Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";")
			},
		  diagnostics = {
				enable = true,
			  globals = {
					"vim"
				}
		  },
			workspace = {
				library = {
					[utils.expand('$VIMRUNTIME/lua')] = true,
					[utils.expand('$VIMRUNTIME/lua/vim/lsp')] = true
				}
			}
	  }
  }
}

lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

core.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { noremap = true, expr = true})
core.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { noremap = true, expr = true})
core.api.nvim_set_keymap('n', '<leader>gs', ':Gstatus<cr>', {noremap = true, silent = true})

core.o.completeopt = 'menuone,noinsert,noselect'
core.o.shortmess = vim.o.shortmess .. 'c'
core.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

core.o.compatible = false
core.o.termguicolors = true
core.o.background = 'dark'
core.o.encoding = 'UTF-8'
core.o.tabstop = 2
core.o.smarttab = true
core.o.autoindent = true
core.o.shiftwidth = 2
core.o.softtabstop = 2
core.o.backup = false
--core.o.signs = true
