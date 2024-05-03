return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-live-grep-args.nvim',
    'aaronhallaert/advanced-git-search.nvim',
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
  },
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy find files' } },
    { '<A-l>', '<cmd>Telescope<cr>' },
    { '<A-;>', '<cmd>Telescope resume<cr>' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
    {
      '<leader>fs',
      function() require('telescope.builtin').lsp_document_symbols { ignore_symbols = 'property' } end,
    },
    {
      '<leader>gb',
      function() require('telescope.builtin').git_branches { initial_mode = 'normal', default_selection_index = 2 } end,
    },
    {
      '<leader>gc',
      function() require('telescope.builtin').git_commits { initial_mode = 'normal', default_selection_index = 2 } end,
    },
    {
      '<leader>fw',
      function() require('telescope.builtin').live_grep { default_text = vim.fn.expand '<cword>' } end,
    },
  },
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'

    require('telescope').setup {
      defaults = {
        path_display = { 'smart' },
        preview = {
          filesize_limit = 1,
        },
        theme = 'dropdown',
        mappings = {
          i = {
            ['<C-h>'] = 'which_key',
            ['<C-a>'] = 'select_all',
            ['<C-q'] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          n = {
            ['<C-a>'] = 'select_all',
            ['<C-q'] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          theme = 'dropdown',
        },
        live_grep = {
          mappings = {
            i = {
              ['<c-f>'] = actions.to_fuzzy_refine,
              ['<c-space>'] = actions.to_fuzzy_refine,
              ['<C-q'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            n = {
              ['f'] = actions.to_fuzzy_refine,
              ['<C-q'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        },
      },
    }

    telescope.load_extension 'fzf'
    telescope.load_extension 'advanced_git_search'
  end,
}
