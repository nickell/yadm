return {
  'tpope/vim-unimpaired',
  { 'kylechui/nvim-surround', version = '*', event = 'VeryLazy', config = true },
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
    'windwp/nvim-ts-autotag',
    event = 'VeryLazy',
    opts = {},
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'navarasu/onedark.nvim',
    config = function()
      local onedark = require 'onedark'
      onedark.setup { style = 'deep' }
      onedark.load()
    end,
  },
  'christoomey/vim-sort-motion',
  { 'numToStr/Navigator.nvim', config = true },
  { 'numToStr/Comment.nvim', config = true },
  'tpope/vim-sensible',
  'tpope/vim-abolish',
  { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = 'nvim-treesitter/nvim-treesitter' },
  'kevinhwang91/rnvimr',
}
