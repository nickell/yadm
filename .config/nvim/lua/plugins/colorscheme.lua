return {
  'AlexvZyl/nordic.nvim',
  lazy = false,
  priority = 1000,
  config = function() require('nordic').load() end,
}

-- return {
--   'savq/melange-nvim',
--   lazy = false,
--   priority = 1000,
--   config = function() vim.cmd 'colorscheme melange' end,
-- }

-- return {
--   'ellisonleao/gruvbox.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd 'set background=dark'
--     vim.cmd 'colorscheme gruvbox'
--   end,
-- }

-- return {
--   'rebelot/kanagawa.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function() vim.cmd 'colorscheme kanagawa' end,
-- }

-- return {
--   'catppuccin/nvim',
--   name = 'catppuccin',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('catppuccin').setup {
--       flavour = 'macchiato',
--     }
--     vim.cmd.colorscheme 'catppuccin-macchiato'
--   end,
-- }

-- return {
--   'folke/tokyonight.nvim',
--   lazy = false,
--   priority = 1000,
--   opts = {},
--   config = function()
--     require('tokyonight').setup()
--     vim.cmd [[colorscheme tokyonight-moon]]
--   end,
-- }

-- return {
--   -- add dracula
--   {
--     'Mofiqul/dracula.nvim',
--     priority = 100,
--     lazy = false,
--     config = function() vim.cmd [[colorscheme dracula]] end,
--   },
-- }
