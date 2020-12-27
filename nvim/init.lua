core = require 'core'
plugins = require 'plugins'
utils = require 'utils'

core.cmd 'packadd paq-nvim'

local paq = require('paq-nvim').paq

paq {'savq/paq-nvim', opt = true}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'neovim/nvim-lspconfig'}
paq {'junegunn/fzf', hook = core.fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'ojroques/nvim-lspfuzzy'}
paq {'nvim-lua/completion-nvim'}
paq {'numtostr/FTerm.nvim'}

local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

local lsp = require 'lspconfig'
local completion_attach = require 'completion'.on_attach

local lspfuzzy = require 'lspfuzzy'

lsp.bashls.setup {}

lsp.intelephense.setup {
	on_attach = completion_attach,
	cmd = {"/usr/local/bin/intelephense", "--stdio"}
}

lsp.jsonls.setup {}

lsp.sumneko_lua.setup {
	on_attach = completion_attach,
  cmd = {"/home/erich/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/bin/Linux/lua-language-server", "-E", "/home/erich/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/main.lua"};
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

paq {'zefei/simple-dark', hook = function() core.cmd 'color simple-dark'; core.cmd 'syntax on' end}

core.cmd 'color simple-dark'
core.cmd 'syntax on'

core.g.mapleader = " "

core.api.nvim_set_keymap('n', '<leader>f', ':Files<cr>', { noremap = true, silent = true })
core.api.nvim_set_keymap('n', '<leader>lb', ':Buffers<cr>', { noremap = true, silent = true })
core.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { noremap = true, expr = true})
core.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { noremap = true, expr = true})
core.api.nvim_set_keymap('n', '<A-i>', '<CMD>lua require"FTerm".toggle()<cr>', { noremap = true, silent = true})
core.api.nvim_set_keymap('t', '<A-i>', '<C-\\><C-n><CMD>lua require"FTerm".toggle()<cr>', { noremap = true, silent = true})

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
