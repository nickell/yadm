return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'Mofiqul/dracula.nvim' },
  opts = {
    options = {
      theme = 'dracula-nvim',
    },
    sections = {
      lualine_x = { 'filetype' },
    },
  },
}
