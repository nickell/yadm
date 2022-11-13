-- vim: foldmethod=marker

-- {{{ functions
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

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'

  use {
    'kylechui/nvim-surround',
    tag = '*',
    config = function() require('nvim-surround').setup {} end,
  }

  use 'nvim-tree/nvim-web-devicons'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local treesitter_update = require('nvim-treesitter.install').update { with_sync = true }
      treesitter_update()
    end,
  }

  use {
    {
      'williamboman/mason.nvim',
      config = function() require('mason').setup() end,
    },
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    {
      'jose-elias-alvarez/null-ls.nvim',
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
    },
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  }

  use {
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      requires = { { 'nvim-lua/plenary.nvim' } },
    },
    'nvim-telescope/telescope-file-browser.nvim',
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

  use 'lewis6991/gitsigns.nvim'
  use 'christoomey/vim-sort-motion'

  use {
    {
      'numToStr/Navigator.nvim',
      config = function() require('Navigator').setup() end,
    },
    {
      'numToStr/Comment.nvim',
      config = function() require('Comment').setup() end,
    },
  }

  use {
    'tpope/vim-fugitive',
    'tpope/vim-sensible',
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = { query = '@class.outer', desc = 'Next class start' },
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
              ['ac'] = '@conditional.outer',
              ['ic'] = '@conditional.inner',
              ['aa'] = '@call.outer',
              ['ia'] = '@call.inner',
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@call.outer'] = 'v', -- charwise
              ['@conditional.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@block.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
          },
        },
      }
    end,
  }

  if packer_bootstrap then require('packer').sync() end
end)
