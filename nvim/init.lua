core = require 'core'
utils = require 'utils'

core.cmd 'packadd plugins'

local sumneko_path = vim.fn.expand('$HOME/Projects/lua-language-server')

local paq = require('plugins').plugins

paq {'liuchengxu/vim-which-key'}

paq {'nvim-treesitter/nvim-treesitter'}
paq {'neovim/nvim-lspconfig', hooks = {
	init = function()
		core.keymap('n', '<leader>lh', ':lua vim.lsp.buf.hover()<cr>')
		core.keymap('n', '<leader>ld', ':lua vim.lsp.buf.decleration()<cr>')
		core.keymap('n', '<leader>lde', ':lua vim.lsp.buf.definition()<cr>')
		core.keymap('n', '<leader>li', ':lua vim.lsp.buf.implementation()<cr>')
		core.keymap('n', '<leader>ls', ':lua vim.lsp.buf.signature_help()<cr>')
		core.keymap('n', '<leader>td', ':lua vim.lsp.buf.type_definition()<cr>')
		core.keymap('n', '<leader>lr', ':lua vim.lsp.buf.references()<cr>')
		core.keymap('n', '<leader>lR', ':lua vim.lsp.buf.rename()<cr>')

		core.cmd 'setlocal omnifunc=v:lua.vim.lsp.omnifunc'
	end
}}
paq {'junegunn/fzf', hooks = { install = core.fn['fzf#install']}}
paq {'junegunn/fzf.vim'}
paq {'ojroques/nvim-lspfuzzy'}
paq {'nvim-lua/completion-nvim'}
paq {'numtostr/FTerm.nvim'}

--core.theme(paq, 'zefei/simple-dark', 'simple-dark')
core.theme(paq, 'sts10/vim-pink-moon', 'pink-moon')

paq {'liuchengxu/vista.vim', hooks = {
	init = function ()
		core.g.vista_default_executive = 'nvim_lsp' -- neovim-lspconfig
		--core.keymap('n', '<leader>tb', ':Vista!!<cr>')
		core.api.nvim_set_keymap('n', '<leader>tb', ':Vista!!<cr>', {noremap = true, silent = true})
	end
	}
}

local ts = require 'nvim-treesitter.configs'
ts.setup {highlight = {enable = true}}

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

core.g.mapleader = " "

core.api.nvim_set_keymap('n', '<leader>f', ':Files<cr>', { noremap = true, silent = true })
core.api.nvim_set_keymap('n', '<leader>lb', ':Buffers<cr>', { noremap = true, silent = true })
core.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { noremap = true, expr = true})
core.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { noremap = true, expr = true})
core.api.nvim_set_keymap('n', '<A-i>', '<CMD>lua require"FTerm".toggle()<cr>', { noremap = true, silent = true})
core.api.nvim_set_keymap('t', '<A-i>', '<C-\\><C-n><CMD>lua require"FTerm".toggle()<cr>', { noremap = true, silent = true})
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
