return {
  'nvim-tree/nvim-tree.lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local nvimtree = require 'nvim-tree'

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup {
      view = {
        width = 35,
        relativenumber = true,
      },
      renderer = {
        icons = {
          glyphs = {
            folder = {
              arrow_closed = '',
              arrow_open = '',
            },
          },
        },
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      git = {
        ignore = false,
      },
    }

    local keymap = vim.keymap -- for conciseness

    -- keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set('n', '<C-n>', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file explorer on current file' }) -- toggle file explorer on current file
    -- keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    -- keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end,
}
