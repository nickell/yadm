return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    { 'nvim-neotest/nvim-nio', tag = 'v1.9.0' },
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'marilari88/neotest-vitest',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-vitest',
      },
    }
  end,
  keys = {
    {
      '<leader>ts',
      function() require('neotest').summary.toggle() end,
    },
    {
      '<leader>o',
      function() require('neotest').output.open { auto_close = true, quiet = true } end,
    },
    {
      '<leader>r',
      function() require('neotest').run.run() end,
    },
    {
      '<leader>tw',
      function() require('neotest').watch.toggle() end,
    },
    {
      '<leader>to',
      '<cmd>:AV<cr>',
    },
  },
}
