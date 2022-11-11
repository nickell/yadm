local keymaps = require 'keymaps'

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function next_hunk()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end

    local function prev_hunk()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end

    keymaps.git {
      bufnr = bufnr,
      next_hunk = next_hunk,
      prev_hunk = prev_hunk,
    }
  end,
}
