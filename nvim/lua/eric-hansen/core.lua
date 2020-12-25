local api = vim.api
local utils = plugin('utils')

local keymaps = {
	__newindex = function (table, key, value)
		local opts = {noremap = true, silent = true}

		utils.table_concat(value[2] or {}, opts)

		api.nvim_set_keymap(key, value[0], value[1], value[2] or {})
	end
};

M = {
  api = api,
  call = function(cmd, ...) args = {...}; vim.fn[cmd](args) end,
  has = function(dat) return vim.fn.has(dat) == 1 end,
  cmd = vim.cmd,
  global = {
    option = {
      set = api.nvim_set_option,
      get = api.nvim_get_option
    },
    var = {
      set = api.nvim_set_var,
      get = api.nvim_get_var,
      del = api.nvim_del_var
    },
    keymap = {
      set = api.nvim_set_keymap,
      get = api.nvim_get_keymap,
      del = api.nvim_del_keymap
    }
  },
  buffer = {
    option = {
      set = api.nvim_buf_set_option,
      get = api.nvim_buf_get_option
    },
    var = {
      set = api.nvim_buf_set_var,
      get = api.nvim_buf_get_var,
      del = api.nvim_buf_del_var
    },
    keymap = {
      set = api.nvim_buf_set_keymap,
      get = api.nvim_buf_get_keymap,
      del = api.nvim_buf_del_keymap
    }
  },
  window = {
    option = {
      set = api.nvim_win_set_option,
      get = api.nvim_win_get_option
    },
    var = {
      set = api.nvim_win_set_var,
      get = api.nvim_win_get_var,
      del = api.nvim_win_del_var
    }
  },
  tab = {
    var = {
      set = api.nvim_tabpage_set_var,
      get = api.nvim_tabpage_get_var,
      del = api.nvim_tabpage_del_var
    }
  },
  vim = {
    var = {
      set = api.nvim_set_vvar,
      get = api.nvim_get_vvar
    }
  }
}

-- Could not get any of my lua files to load so modified package path
package.path = package.path .. ";" .. utils.stdpath("config") .. "/lua/?.lua"

M.global.var.set('mapleader', ',')

return M
