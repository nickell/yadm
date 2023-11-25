return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    event = { 'VeryLazy' },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require 'nvim-treesitter.query_predicates'
    end,
    dependencies = {
      { 'stevearc/aerial.nvim' },
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require 'nvim-treesitter.textobjects.move' ---@type table<string,fun(...)>
          local configs = require 'nvim-treesitter.configs'
          for name, fn in pairs(move) do
            if name:find 'goto' == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find '[%]%[][cC]' then
                      vim.cmd('normal! ' .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    opts = {
      highlight = {
        enable = true,
        -- Disable slow treesitter highlight for large files
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return true end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      ensure_installed = {
        'bash',
        'c',
        'comment',
        'css',
        'diff',
        'dockerfile',
        'git_rebase',
        'gitignore',
        'html',
        'http',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'make',
        'markdown',
        'markdown_inline',
        'prisma',
        'python',
        'query',
        'regex',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
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
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then return false end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'stevearc/aerial.nvim',
    -- Call the setup function to change the default behavior
    opts = {
      -- Determines how the aerial window decides which buffer to display symbols for
      --   window - aerial window will display symbols for the buffer in the window from which it was opened
      --   global - aerial window will display symbols for the current window
      -- attach_mode = 'global',

      -- List of enum values that configure when to auto-close the aerial window
      --   unfocus       - close aerial when you leave the original source window
      --   switch_buffer - close aerial when you change buffers in the source window
      --   unsupported   - close aerial when attaching to a buffer that has no symbol source
      -- close_automatic_events = { 'unsupported' },

      -- Disable aerial on files with this many lines
      disable_max_lines = 10000,

      -- Disable aerial on files this size or larger (in bytes)
      disable_max_size = 2000000, -- Default 2MB

      -- A list of all symbols to display. Set to false to display all symbols.
      -- This can be a filetype map (see :help aerial-filetype-map)
      -- To see all available values, see :help SymbolKind
      filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
      },

      -- Jump to symbol in source window when the cursor moves
      autojump = true,

      manage_folds = false,

      -- Automatically open aerial when entering supported buffers.
      -- This can be a function (see :help aerial-open-automatic)
      open_automatic = function(bufnr)
        local aerial = require 'aerial'
        -- Enforce a minimum line count
        return vim.api.nvim_buf_line_count(bufnr) > 80
          -- Enforce a minimum symbol count
          and aerial.num_symbols(bufnr) > 1
          -- A useful way to keep aerial closed when closed manually
          and not aerial.was_closed()
      end,
    },
    config = false,
    keys = {
      { '<leader>a', function() require('aerial').toggle() end },
    },
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
      'stevearc/stickybuf.nvim',
    },
  },
  {
    'stevearc/stickybuf.nvim',
    opts = {},
  },
}
