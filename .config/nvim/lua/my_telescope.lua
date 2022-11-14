local telescope = require 'telescope'
local action_state = require 'telescope.actions.state'
local actions = require 'telescope.actions'

local function multiopen(prompt_bufnr, method)
  local edit_file_cmd_map = {
    vertical = 'vsplit',
    horizontal = 'split',
    tab = 'tabedit',
    default = 'edit',
  }
  local edit_buf_cmd_map = {
    vertical = 'vert sbuffer',
    horizontal = 'sbuffer',
    tab = 'tab sbuffer',
    default = 'buffer',
  }
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()

  if #multi_selection > 1 then
    require('telescope.pickers').on_close_prompt(prompt_bufnr)
    pcall(vim.api.nvim_set_current_win, picker.original_win_id)

    for i, entry in ipairs(multi_selection) do
      local filename, row, col

      if entry.path or entry.filename then
        filename = entry.path or entry.filename

        row = entry.row or entry.lnum
        col = vim.F.if_nil(entry.col, 1)
      elseif not entry.bufnr then
        local value = entry.value
        if not value then return end

        if type(value) == 'table' then value = entry.display end

        local sections = vim.split(value, ':')

        filename = sections[1]
        row = tonumber(sections[2])
        col = tonumber(sections[3])
      end

      local entry_bufnr = entry.bufnr

      if entry_bufnr then
        if not vim.api.nvim_buf_get_option(entry_bufnr, 'buflisted') then
          vim.api.nvim_buf_set_option(entry_bufnr, 'buflisted', true)
        end
        local command = i == 1 and 'buffer' or edit_buf_cmd_map[method]
        pcall(vim.cmd, string.format('%s %s', command, vim.api.nvim_buf_get_name(entry_bufnr)))
      else
        local command = i == 1 and 'edit' or edit_file_cmd_map[method]
        if vim.api.nvim_buf_get_name(0) ~= filename or command ~= 'edit' then
          filename = require('plenary.path'):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
          pcall(vim.cmd, string.format('%s %s', command, filename))
        end
      end

      if row and col then pcall(vim.api.nvim_win_set_cursor, 0, { row, col }) end
    end
  else
    actions['select_' .. method](prompt_bufnr)
  end
end

local function multiopen_selection(prompt_bufnr) multiopen(prompt_bufnr, 'default') end

require('telescope').setup {
  defaults = {
    theme = 'dropdown',
    mappings = {
      i = {
        -- ["<CR>"] = multiopen_selection,
        ['<C-h>'] = 'which_key',
        ['<C-a>'] = 'select_all',
      },
      n = {
        ['<C-a>'] = 'select_all',
      },
    },
  },
  pickers = {
    find_files = {
      theme = 'dropdown',
      mappings = {
        i = {
          ['<CR>'] = multiopen_selection,
        },
        n = {
          ['<CR>'] = multiopen_selection,
        },
      },
    },
    live_grep = {
      theme = 'dropdown',
      mappings = {
        i = {
          ['<CR>'] = multiopen_selection,
        },
        n = {
          ['<CR>'] = multiopen_selection,
        },
      },
    },
  },
  extensions = {
    file_browser = {
      hidden = true,
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
    },
  },
}

telescope.load_extension 'fzf'
telescope.load_extension 'file_browser'
