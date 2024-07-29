return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'AlexvZyl/nordic.nvim' },
  opts = {
    options = {
      theme = 'nordic',
    },
    sections = {
      lualine_b = { { 'branch', fmt = function(str) return str:sub(1, 30) end }, 'diff', 'diagnostics' },
      lualine_x = { 'filetype' },
    },
    tabline = {},
  },
}
