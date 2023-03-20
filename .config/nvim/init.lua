-- Useful for debugging
-- print(vim.inspect(variable))

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
o.foldlevelstart = 5
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
local tel_builtins = require 'telescope.builtin'

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

local initial_normal_opts = { initial_mode = 'normal', default_selection_index = 2 }

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

vim.g.mapleader = ' '

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
nmap('<Leader>a', tel_builtins.live_grep)
nmap('<Leader>bo', ':%bd|e#|bd#<CR>')
nmap('<Leader>dc', ':DiffviewClose<CR>')
nmap('<Leader>df', ':DiffviewFileHistory %<CR>')
nmap('<Leader>dl', ':DiffviewFileHistory<CR>')
nmap('<Leader>do', ':DiffviewOpen<CR>')
nmap('<Leader>e', vim.diagnostic.open_float)
nmap('<Leader>f', tel_builtins.find_files)
nmap('<Leader>gb', function() tel_builtins.git_branches(initial_normal_opts) end)
nmap('<Leader>gc', function() tel_builtins.git_commits(initial_normal_opts) end)
nmap('<Leader>gs', ':Git<CR>')
nmap('<Leader>h', '<Plug>RestNvim', { silent = true })
nmap('<Leader>j', vim.diagnostic.goto_next)
nmap('<Leader>k', vim.diagnostic.goto_prev)
nmap('<Leader>q', vim.diagnostic.setloclist)
nmap('<Leader>rw', function() tel_builtins.live_grep { default_text = vim.fn.expand '<cword>' } end)
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

xnoremap <expr> <Plug>(DBExe)     DBExe()
nnoremap <expr> <Plug>(DBExe)     DBExe()
nnoremap <expr> <Plug>(DBExeLine) DBExe() . '_'

xmap <leader>db  <Plug>(DBExe)
nmap <leader>db  <Plug>(DBExe)
omap <leader>db  <Plug>(DBExe)
nmap <leader>dbb <Plug>(DBExeLine)
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

Keymaps.lsp = function(bufnr, lsp_formatting)
  local _opts = { noremap = true, silent = true, buffer = bufnr }
  nmap('<Leader>D', vim.lsp.buf.type_definition, _opts)
  nmap('<Leader>ca', vim.lsp.buf.code_action, _opts)
  nmap('<Leader>td', vim.lsp.buf.definition, _opts)
  nmap('<Leader>lr', vim.lsp.buf.references, _opts)
  nmap('<Leader>p', function() lsp_formatting(_opts.bufnr, true) end, _opts)
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

-- {{{ packer
-- {{{ plugin functions
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]
-- }}}

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'

  use { 'kylechui/nvim-surround', tag = '*', config = function() require('nvim-surround').setup {} end }

  use 'nvim-tree/nvim-web-devicons'

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = 'neovim/nvim-lspconfig',
    run = ':TSUpdate',
    --  {{{ treesitter config
    config = function()
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
          disable = function(_, buf)
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
    end,
    --  }}}
  }

  use {
    'kevinhwang91/promise-async',
    {
      'kevinhwang91/nvim-ufo',
      requires = { 'nvim-treesitter/nvim-treesitter', 'kevinhwang91/promise-async' },
      config = function()
        require('ufo').setup {
          provider_selector = function() return { 'treesitter', 'indent' } end,
        }

        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      end,
    },
  }

  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
    {
      'neovim/nvim-lspconfig',
      requires = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'lukas-reineke/lsp-format.nvim',
      },
      --  {{{ config
      config = function()
        require('mason').setup()
        require('lsp-format').setup()

        local lspconfig = require 'lspconfig'
        local mason_lspconfig = require 'mason-lspconfig'
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspformat = require 'lsp-format'

        local lsp_formatting = function(bufnr, isAsync)
          vim.lsp.buf.format {
            async = isAsync,
            filter = function(client) return client.name == 'null-ls' end,
            bufnr = bufnr,
          }
        end

        local lspFormattingAugroup = vim.api.nvim_create_augroup('LspFormatting', {})

        local on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = lspFormattingAugroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = lspFormattingAugroup,
              buffer = bufnr,
              callback = function() lsp_formatting(bufnr, false) end,
            })
          end

          lspformat.on_attach(client)

          Keymaps.lsp(bufnr, lsp_formatting)
        end

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
      --  }}}
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      --  {{{ null-ls config
      config = function()
        local null_ls = require 'null-ls'

        null_ls.setup {
          sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.code_actions.gitsigns,
          },
        }
      end,
      --  }}}
    },
    'saadparwaiz1/cmp_luasnip',
    {
      'L3MON4D3/LuaSnip',
      --  {{{ luasnip config
      config = function()
        local ls = require 'luasnip'

        ls.setup { history = false, updateevents = 'TextChanged,TextChangedI' }

        ls.filetype_extend('typescript', { 'javascript' })
        ls.filetype_extend('typescriptreact', { 'typescript', 'javascript' })

        require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/lua/snippets' }
      end,
      --  }}}
    },
    {
      'hrsh7th/nvim-cmp',
      --  {{{ nvim-cmp config
      config = function()
        local cmp = require 'cmp'
        local ls = require 'luasnip'

        cmp.setup {
          snippet = {
            expand = function(args) ls.lsp_expand(args.body) end,
          },
          mapping = Keymaps.cmp(cmp, ls),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          },
        }
      end,
      --  }}}
    },
  }

  use {
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      requires = { { 'nvim-lua/plenary.nvim' } },
      --  {{{ telescope setup
      config = function()
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
            fzf = {
              fuzzy = true, -- false will only do exact matching
              override_generic_sorter = true, -- override the generic sorter
              override_file_sorter = true, -- override the file sorter
              case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
            },
          },
        }

        telescope.load_extension 'fzf'
      end,
      --  }}}
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
  }

  use {
    'akinsho/bufferline.nvim',
    tag = 'v3.*',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function() require('bufferline').setup() end,
  }

  use {
    'navarasu/onedark.nvim',
    config = function()
      local onedark = require 'onedark'
      onedark.setup { style = 'deep' }
      onedark.load()
    end,
  }

  use {
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
  }

  use 'christoomey/vim-sort-motion'

  use {
    { 'numToStr/Navigator.nvim', config = function() require('Navigator').setup() end },
    { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
  }

  use { 'tpope/vim-fugitive', 'tpope/vim-sensible', 'tpope/vim-abolish' }

  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    --  {{{ diffview config
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
    --  }}}
  }

  use 'kevinhwang91/rnvimr'

  use {
    'rest-nvim/rest.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    --  {{{ rest.nvim config
    config = function()
      require('rest-nvim').setup {
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = true,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to nil if you want to disable them
          formatters = {
            json = 'jq',
            html = function(body) return vim.fn.system({ 'tidy', '-i', '-q', '-' }, body) end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
      }
    end,
    --  }}}
  }

  use {
    'tpope/vim-dadbod',
    config = function()
      vim.cmd [[
func! DBExe(...)
	if !a:0
		let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
		return 'g@'
	endif
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@

	if a:1 == 'char'	" Invoked from Visual mode, use gv command.
		silent exe 'normal! gvy'
	elseif a:1 == 'line'
		silent exe "normal! '[V']y"
	else
		silent exe 'normal! `[v`]y'
	endif

	execute "DB " . @@

	let &selection = sel_save
	let @@ = reg_save
endfunc
    ]]
    end,
  }

  if packer_bootstrap then require('packer').sync() end
end)
--  }}}
