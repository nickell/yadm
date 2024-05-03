return {
  'kevinhwang91/nvim-ufo',
  lazy = true,
  dependencies = { 'kevinhwang91/promise-async' },
  keys = {
    {
      'zR',
      function() require('ufo').openAllFolds() end,
      desc = 'Open all folds',
    },
    {
      'zM',
      function() require('ufo').closeAllFolds() end,
      desc = 'Close all folds',
    },
  },
  config = false,
}
