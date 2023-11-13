vim.g.mapleader = ' '

-- Useful for debugging
-- print(vim.inspect(variable))

-- {{{ lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local lazyVimOpts = {
  -- defaults = {
  --   lazy = true,
  -- },
}

require('lazy').setup({
  'tpope/vim-unimpaired',
  { 'kylechui/nvim-surround', version = '*', event = 'VeryLazy', config = true },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>p',
        function() require('conform').format { async = true, lsp_fallback = true } end,
        desc = 'Format buffer',
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

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
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      require('ufo').setup {
        provider_selector = function() return { 'lsp', 'indent' } end,
      }

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    -- load cmp on InsertEnter
    event = 'InsertEnter',
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      -- ...
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('mason').setup()
      local lspconfig = require 'lspconfig'
      local mason_lspconfig = require 'mason-lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(_, bufnr) Keymaps.lsp(bufnr) end

      mason_lspconfig.setup {
        ensure_installed = {
          'cssls',
          'denols',
          'dockerls',
          'eslint',
          'html',
          'jsonls',
          'pyright',
          'lua_ls',
          'tailwindcss',
          'tsserver',
          'vimls',
          'yamlls',
        },
        automatic_installation = true,
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }
        end,
        ['tsserver'] = function()
          local nvim_lsp = require 'lspconfig'

          lspconfig.tsserver.setup {
            capabilities = capabilities,
            single_file_support = false,
            root_dir = nvim_lsp.util.root_pattern 'package.json',
            on_attach = function(client, bufnr)
              on_attach(client, bufnr)
              Keymaps.tsserver(bufnr)
            end,
          }
        end,
        ['denols'] = function()
          local nvim_lsp = require 'lspconfig'

          lspconfig.denols.setup {
            capabilities = capabilities,
            root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc'),
            on_attach = on_attach,
          }
        end,
        ['lua_ls'] = function()
          lspconfig.lua_ls.setup {
            on_attach = on_attach,
            settings = {
              Lua = {
                runtime = {
                  version = 'LuaJIT',
                },
                diagnostics = {
                  globals = { 'vim', 's', 't', 'i', 'f', 'fmt', 'fmta', 'rep', 'conds', 'sn', 'd', 'c', 'extras' },
                },
              },
            },
          }
        end,
      }
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
      'aaronhallaert/advanced-git-search.nvim',
      'tpope/vim-fugitive',
      'tpope/vim-rhubarb',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end },
      { '<A-l>', function() require('telescope.builtin').builtin() end },
      { '<A-;>', function() require('telescope.builtin').resume() end },
      { '<leader>fg', function() require('telescope').extensions.live_grep_args.live_grep_args() end },
      {
        '<leader>fs',
        function() require('telescope.builtins').lsp_document_symbols { ignore_symbols = 'property' } end,
      },
      {
        '<leader>gb',
        function() require('telescope.builtins').git_branches { initial_mode = 'normal', default_selection_index = 2 } end,
      },
      {
        '<leader>gc',
        function() require('telescope.builtins').git_commits { initial_mode = 'normal', default_selection_index = 2 } end,
      },
      {
        '<leader>fw',
        function() require('telescope.builtins').live_grep { default_text = vim.fn.expand '<cword>' } end,
      },
    },
    config = function()
      local telescope = require 'telescope'
      local action_state = require 'telescope.actions.state'
      local actions = require 'telescope.actions'
      local lga_actions = require 'telescope-live-grep-args.actions'

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
          preview = {
            filesize_limit = 1,
          },
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
            hidden = true,
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
          live_grep_args = {
            auto_quoting = true,
            mappings = { -- extend mappings
              i = {
                ['<C-k>'] = lga_actions.quote_prompt(),
                ['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob **/' },
              },
            },
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
      telescope.load_extension 'live_grep_args'
      telescope.load_extension 'advanced_git_search'
    end,
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    'navarasu/onedark.nvim',
    config = function()
      local onedark = require 'onedark'
      onedark.setup { style = 'deep' }
      onedark.load()
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    --  {{{ gitsigns setup
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = require 'gitsigns'
          -- local gs = package.loaded.gitsigns

          local function next_hunk()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end

          local function prev_hunk()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end

          Keymaps.git {
            bufnr = bufnr,
            next_hunk = next_hunk,
            prev_hunk = prev_hunk,
          }
        end,
      }
    end,
    --  }}}
  },
  'christoomey/vim-sort-motion',
  { 'numToStr/Navigator.nvim', config = true },
  { 'numToStr/Comment.nvim', config = true },
  'tpope/vim-sensible',
  'tpope/vim-abolish',
  { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = 'nvim-treesitter/nvim-treesitter' },
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      local actions = require 'diffview.actions'

      require('diffview').setup {
        diff_binaries = false, -- Show diffs for binaries
        enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        git_cmd = { 'git' }, -- The git executable followed by default args.
        use_icons = true, -- Requires nvim-web-devicons
        watch_index = true, -- Update views and index buffers when the git index changes.
        icons = {
          -- Only applies when use_icons is true.
          folder_closed = '',
          folder_open = '',
        },
        signs = {
          fold_closed = '',
          fold_open = '',
          done = '✓',
        },
        view = {
          -- Configure the layout and behavior of different types of views.
          -- Available layouts:
          --  'diff1_plain'
          --    |'diff2_horizontal'
          --    |'diff2_vertical'
          --    |'diff3_horizontal'
          --    |'diff3_vertical'
          --    |'diff3_mixed'
          --    |'diff4_mixed'
          -- For more info, see ':h diffview-config-view.x.layout'.
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = 'diff2_horizontal',
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = 'diff3_horizontal',
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
          },
          file_history = {
            -- Config for changed files in file history views.
            layout = 'diff2_horizontal',
          },
        },
        file_panel = {
          listing_style = 'tree', -- One of 'list' or 'tree'
          tree_options = {
            -- Only applies when listing_style is 'tree'
            flatten_dirs = true, -- Flatten dirs that only contain one single dir
            folder_statuses = 'only_folded', -- One of 'never', 'only_folded' or 'always'.
          },
          win_config = {
            -- See ':h diffview-config-win_config'
            position = 'left',
            width = 35,
            win_opts = {},
          },
        },
        file_history_panel = {
          log_options = {
            -- See ':h diffview-config-log_options'
            git = {
              single_file = {
                diff_merges = 'combined',
              },
              multi_file = {
                diff_merges = 'first-parent',
              },
            },
          },
          win_config = {
            -- See ':h diffview-config-win_config'
            position = 'bottom',
            height = 16,
            win_opts = {},
          },
        },
        commit_log_panel = {
          win_config = { -- See ':h diffview-config-win_config'
            win_opts = {},
          },
        },
        default_args = {
          -- Default args prepended to the arg-list for the listed commands
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {}, -- See ':h diffview-config-hooks'
        keymaps = {
          disable_defaults = false, -- Disable the default keymaps
          view = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            ['<tab>'] = actions.select_next_entry, -- Open the diff for the next file
            ['<s-tab>'] = actions.select_prev_entry, -- Open the diff for the previous file
            ['gf'] = actions.goto_file, -- Open the file in a new split in the previous tabpage
            ['<C-w><C-f>'] = actions.goto_file_split, -- Open the file in a new split
            ['<C-w>gf'] = actions.goto_file_tab, -- Open the file in a new tabpage
            ['<leader>e'] = actions.focus_files, -- Bring focus to the file panel
            ['<leader>b'] = actions.toggle_files, -- Toggle the file panel.
            ['g<C-x>'] = actions.cycle_layout, -- Cycle through available layouts.
            ['[x'] = actions.prev_conflict, -- In the merge_tool: jump to the previous conflict
            [']x'] = actions.next_conflict, -- In the merge_tool: jump to the next conflict
            ['<leader>co'] = actions.conflict_choose 'ours', -- Choose the OURS version of a conflict
            ['<leader>ct'] = actions.conflict_choose 'theirs', -- Choose the THEIRS version of a conflict
            ['<leader>cb'] = actions.conflict_choose 'base', -- Choose the BASE version of a conflict
            ['<leader>ca'] = actions.conflict_choose 'all', -- Choose all the versions of a conflict
            ['dx'] = actions.conflict_choose 'none', -- Delete the conflict region
          },
          diff1 = { --[[ Mappings in single window diff layouts ]]
          },
          diff2 = { --[[ Mappings in 2-way diff layouts ]]
          },
          diff3 = {
            -- Mappings in 3-way diff layouts
            { { 'n', 'x' }, '2do', actions.diffget 'ours' }, -- Obtain the diff hunk from the OURS version of the file
            { { 'n', 'x' }, '3do', actions.diffget 'theirs' }, -- Obtain the diff hunk from the THEIRS version of the file
          },
          diff4 = {
            -- Mappings in 4-way diff layouts
            { { 'n', 'x' }, '1do', actions.diffget 'base' }, -- Obtain the diff hunk from the BASE version of the file
            { { 'n', 'x' }, '2do', actions.diffget 'ours' }, -- Obtain the diff hunk from the OURS version of the file
            { { 'n', 'x' }, '3do', actions.diffget 'theirs' }, -- Obtain the diff hunk from the THEIRS version of the file
          },
          file_panel = {
            ['j'] = actions.next_entry, -- Bring the cursor to the next file entry
            ['<down>'] = actions.next_entry,
            ['k'] = actions.prev_entry, -- Bring the cursor to the previous file entry.
            ['<up>'] = actions.prev_entry,
            ['<cr>'] = actions.select_entry, -- Open the diff for the selected entry.
            ['o'] = actions.select_entry,
            ['<2-LeftMouse>'] = actions.select_entry,
            ['-'] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
            ['S'] = actions.stage_all, -- Stage all entries.
            ['U'] = actions.unstage_all, -- Unstage all entries.
            ['X'] = actions.restore_entry, -- Restore entry to the state on the left side.
            ['L'] = actions.open_commit_log, -- Open the commit log panel.
            ['<c-b>'] = actions.scroll_view(-0.25), -- Scroll the view up
            ['<c-f>'] = actions.scroll_view(0.25), -- Scroll the view down
            ['<tab>'] = actions.select_next_entry,
            ['<s-tab>'] = actions.select_prev_entry,
            ['gf'] = actions.goto_file,
            ['<C-w><C-f>'] = actions.goto_file_split,
            ['<C-w>gf'] = actions.goto_file_tab,
            ['i'] = actions.listing_style, -- Toggle between 'list' and 'tree' views
            ['f'] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.
            ['R'] = actions.refresh_files, -- Update stats and entries in the file list.
            ['<leader>e'] = actions.focus_files,
            ['<leader>b'] = actions.toggle_files,
            ['g<C-x>'] = actions.cycle_layout,
            ['[x'] = actions.prev_conflict,
            [']x'] = actions.next_conflict,
          },
          file_history_panel = {
            ['g!'] = actions.options, -- Open the option panel
            ['<C-A-d>'] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
            ['y'] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
            ['L'] = actions.open_commit_log,
            ['zR'] = actions.open_all_folds,
            ['zM'] = actions.close_all_folds,
            ['j'] = actions.next_entry,
            ['<down>'] = actions.next_entry,
            ['k'] = actions.prev_entry,
            ['<up>'] = actions.prev_entry,
            ['<cr>'] = actions.select_entry,
            ['o'] = actions.select_entry,
            ['<2-LeftMouse>'] = actions.select_entry,
            ['<c-b>'] = actions.scroll_view(-0.25),
            ['<c-f>'] = actions.scroll_view(0.25),
            ['<tab>'] = actions.select_next_entry,
            ['<s-tab>'] = actions.select_prev_entry,
            ['gf'] = actions.goto_file,
            ['<C-w><C-f>'] = actions.goto_file_split,
            ['<C-w>gf'] = actions.goto_file_tab,
            ['<leader>e'] = actions.focus_files,
            ['<leader>b'] = actions.toggle_files,
            ['g<C-x>'] = actions.cycle_layout,
          },
          option_panel = {
            ['<tab>'] = actions.select_entry,
            ['q'] = actions.close,
          },
        },
      }
    end,
  },
  'kevinhwang91/rnvimr',
}, lazyVimOpts)
--  }}}

--  {{{ options
local o = vim.opt

o.autoindent = true
o.clipboard = 'unnamedplus'
o.expandtab = true
o.ignorecase = true
o.number = true
o.relativenumber = true
o.shiftwidth = 2
o.smartcase = true
o.softtabstop = 2
o.tabstop = 2
o.termguicolors = true
o.wildignorecase = true
o.wrap = false

o.backup = true
o.backupskip = '/tmp/*,/private/tmp/*'
o.swapfile = false
o.writebackup = true

o.history = 100
o.sessionoptions = 'blank,buffers,curdir,folds'
o.undofile = true
o.undolevels = 100

o.foldcolumn = '1'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

-- o.foldlevel = 5
-- o.foldmethod = 'expr'
-- o.foldexpr = 'nvim_treesitter#foldexpr()'

o.backupdir = vim.fn.expand '~/.config/nvim/backup/'
o.directory = vim.fn.expand '~/.config/nvim/swap/'
o.undodir = vim.fn.expand '~/.config/nvim/undo/'
--  }}}

--  {{{ keymaps
-- {{{ requires and functions
-- local tel_builtins = require 'telescope.builtin'

Keymaps = {}

local opts = { noremap = true, silent = true }

local function map(mode, key, command, options)
  options = options or opts
  vim.keymap.set(mode, key, command, options)
end

local function nmap(key, command, options) map('n', key, command, options) end

local function vmap(key, command, options) map('v', key, command, options) end

Keymaps.nmap = nmap
Keymaps.vmap = vmap
Keymaps.opts = opts

-- local initial_normal_opts = { initial_mode = 'normal', default_selection_index = 2 }

local function add_missing_imports()
  vim.lsp.buf.code_action { context = { only = { 'source.addMissingImports' } }, apply = true }
end

local function organize_imports()
  vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
end

--  {{{ Unused but saving
-- inoremap <A-j> <Esc>:m .+1<CR>==gi
-- inoremap <A-k> <Esc>:m .-2<CR>==gi
--  }}}
-- }}}

nmap('-', 'dd')
nmap('<A-j>', ':m .+1<CR>')
nmap('<A-k>', ':m .-2<CR>')
nmap('<A-o>', ':RnvimrToggle<CR>')
nmap('<C-h>', '<CMD>NavigatorLeft<CR>')
nmap('<C-j>', '<CMD>NavigatorDown<CR>')
nmap('<C-k>', '<CMD>NavigatorUp<CR>')
nmap('<C-l>', '<CMD>NavigatorRight<CR>')
nmap('<CR>', 'i<CR><ESC>')
nmap('<Leader><CR>', ':noh<CR>')
-- nmap('<Leader>a', tel_builtins.live_grep)
nmap('<Leader>bo', ':%bd|e#|bd#<CR>')
nmap('<Leader>dc', ':DiffviewClose<CR>')
nmap('<Leader>df', ':DiffviewFileHistory %<CR>')
nmap('<Leader>dl', ':DiffviewFileHistory<CR>')
nmap('<Leader>do', ':DiffviewOpen<CR>')
nmap('<Leader>e', vim.diagnostic.open_float)
-- nmap('<Leader>ff', tel_builtins.find_files)
-- nmap('<A-p>', tel_builtins.find_files)
nmap('<Leader>gs', ':Git<CR>')
-- nmap('<Leader>h', '<Plug>RestNvim', { silent = true })
nmap('<Leader>j', vim.diagnostic.goto_next)
nmap('<Leader>k', vim.diagnostic.goto_prev)
nmap('<Leader>q', vim.diagnostic.setloclist)
nmap('<Leader>s', function() require('luasnip.loaders').edit_snippet_files() end)
nmap('<Leader>w', ':write<CR>')
nmap('<Leader>x', ':bd<CR>')
nmap('<leader><leader>s', '<cmd>source ~/.config/nvim/lua/my_luasnip.lua<CR>')
nmap('L', 'zo')
nmap('H', 'zc')
nmap('zL', 'L')
nmap('zH', 'H')
nmap('QQ', ':quit<CR>')
nmap('X', ':bd<CR>')
nmap('gd', ':bd<CR>')
nmap('gn', ':bn<CR>')
nmap('gp', ':bp<CR>')

map('t', '<M-o>', '<C-\\><C-n>:RnvimrToggle<CR>')
map('t', '<M-i>', '<C-\\><C-n>:RnvimrResize<CR>')

vim.cmd [[
" nnoremap <silent> <M-o> :RnvimrToggle<CR>
" tnoremap <silent> <M-i> <C-\><C-n>:RnvimrResize<CR>
" tnoremap <silent> <M-o> <C-\><C-n>:RnvimrToggle<CR>
let g:rnvimr_enable_picker = 1
let g:rnvimr_enable_bw = 1
" let g:rnvimr_enable_ex = 1
" g:rnvimr_vanilla
  ]]

vmap('<', '<gv')
vmap('<A-j>', ":m '>+1<CR>gv=gv")
vmap('<A-k>', ":m '<-2<CR>gv=gv")
vmap('>', '>gv')

Keymaps.cmp = function(cmp, ls)
  -- {{{ functions
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
  end

  local expand_or_jump = function(fallback)
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    else
      fallback()
    end
  end

  local cycle_completion = function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end

  local cycle_completion_back = function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end

  local luasnip_change_choice = function()
    if ls.choice_active() then ls.change_choice(1) end
  end
  -- }}}

  return cmp.mapping.preset.insert {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping(expand_or_jump, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
    ['<S-Tab>'] = cmp.mapping(cycle_completion_back, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(cycle_completion, { 'i', 's' }),
    ['<C-l'] = cmp.mapping(luasnip_change_choice, { 'i', 's' }),
  }
end

Keymaps.lsp = function(bufnr)
  local _opts = { noremap = true, silent = true, buffer = bufnr }
  nmap('<Leader>D', vim.lsp.buf.type_definition, _opts)
  nmap('<Leader>lca', vim.lsp.buf.code_action, _opts)
  nmap('<Leader>td', vim.lsp.buf.definition, _opts)
  nmap('<Leader>lr', vim.lsp.buf.references, _opts)
  -- nmap('<Leader>p', vim.lsp.buf.format, _opts)
  nmap('<Leader>rn', vim.lsp.buf.rename, _opts)
  nmap('K', vim.lsp.buf.hover, _opts)
  nmap('gD', vim.lsp.buf.declaration, _opts)
  nmap('gi', vim.lsp.buf.implementation, _opts)
end

Keymaps.tsserver = function(bufnr)
  local _opts = { noremap = true, silent = true, buffer = bufnr }
  nmap('<Leader>ti', add_missing_imports, _opts)
  nmap('<Leader>to', organize_imports, _opts)
end

Keymaps.git = function(params)
  local _opts = { expr = true, buffer = params.bufnr }
  nmap('<leader>gb', function() require('gitsigns').blame_line { full = true } end, {})
  nmap('[c', params.prev_hunk, _opts)
  nmap(']c', params.next_hunk, _opts)

  --  {{{ unused
  -- Actions
  -- map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
  -- map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
  -- map('n', '<leader>hS', gs.stage_buffer)
  -- map('n', '<leader>hu', gs.undo_stage_hunk)
  -- map('n', '<leader>hR', gs.reset_buffer)
  -- map('n', '<leader>hp', gs.preview_hunk)
  -- map('n', '<leader>hd', gs.diffthis)
  -- map('n', '<leader>hD', function()
  --   gs.diffthis '~'
  -- end)
  -- map('n', '<leader>td', gs.toggle_deleted)

  -- Text object
  -- map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  --  }}}
end
--  }}}
