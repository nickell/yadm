require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'comment',
    'css',
    'diff',
    'dockerfile',
    'git_rebase',
    'gitignore',
    'html',
    'http',
    'javascript',
    'json',
    'lua',
    'make',
    'markdown',
    'prisma',
    'python',
    'regex',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },
  sync_install = false,
  auto_install = true,
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,
    -- Disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then return true end
    end,
    additional_vim_regex_highlighting = false,
  },

  textobjects = {
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']m'] = '@function.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',
        ['aa'] = '@call.outer',
        ['ia'] = '@call.inner',
      },
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@call.outer'] = 'v', -- charwise
        ['@conditional.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@block.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      include_surrounding_whitespace = true,
    },
  },
}
