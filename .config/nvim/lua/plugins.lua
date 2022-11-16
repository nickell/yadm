-- vim: foldmethod=marker: foldlevel=0:

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

        -- local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

        null_ls.setup {
          -- on_attach = function(client, bufnr)
          --   if client.supports_method 'textDocument/formatting' then
          --     vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          --     vim.api.nvim_create_autocmd('BufWritePre', {
          --       group = augroup,
          --       buffer = bufnr,
          --       callback = function() vim.lsp.buf.format { bufnr = bufnr } end,
          --     })
          --   end
          -- end,
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
    -- 'rafamadriz/friendly-snippets',
  }

  use {
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      requires = { { 'nvim-lua/plenary.nvim' } },
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

  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

  use {
    'lukas-reineke/lsp-format.nvim',
    config = function() require('lsp-format').setup() end,
  }

  use 'kevinhwang91/rnvimr'

  if packer_bootstrap then require('packer').sync() end
end)
