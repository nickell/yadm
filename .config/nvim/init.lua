require 'plugins'
require 'keymaps'
require 'options'

require 'treesitter'
require 'mylspconfig'
require 'nullls'
require 'mytelescope'

require('bufferline').setup {}
require('Navigator').setup {}
require('onedark').setup {
  style = 'deep',
}
require('onedark').load()
require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    -- map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    -- map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    -- map('n', '<leader>hS', gs.stage_buffer)
    -- map('n', '<leader>hu', gs.undo_stage_hunk)
    -- map('n', '<leader>hR', gs.reset_buffer)
    -- map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>gb', function()
      gs.blame_line { full = true }
    end)
    -- map('n', '<leader>tb', gs.toggle_current_line_blame)
    -- map('n', '<leader>hd', gs.diffthis)
    -- map('n', '<leader>hD', function()
    --   gs.diffthis '~'
    -- end)
    -- map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    -- map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
}

-- Configuration

-- This didn't seem to be working...
-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerCompile
--   augroup end
-- ]])
