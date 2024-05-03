return {
  { 'kylechui/nvim-surround', version = '*', event = 'VeryLazy', config = true },
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
