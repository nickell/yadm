return {
  {
    'tpope/vim-unimpaired',
    config = function()
      vim.cmd [[
    unmap =s
    unmap =s<Esc>
    unmap =p
    unmap =P
    ]]
    end,
  },
  { 'kylechui/nvim-surround', version = '*', event = 'VeryLazy', config = true },
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
  'rmagatti/auto-session',
  { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
  {
    'vimwiki/vimwiki',
    init = function()
      vim.cmd [[
let g:vimwiki_map_prefix = '<Leader>e'
      ]]
    end,
    config = function()
      vim.cmd [[
let g:vimwiki_list = [{'path': '~/Documents/notes/', 'syntax': 'markdown', 'ext': 'md'}]
      ]]
    end,
  },
}
