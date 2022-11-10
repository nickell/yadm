local M = {}

M.general = {
  n = {
    -- [";"] = { ":", "command mode", opts = { nowait = true } },
    ["QQ"] = { "<cmd> q <CR>", "quit vim" },
    ["-"] = { "dd", "delete line" },
    ["<leader>w"] = { "<cmd> w <CR>", "write file" },
    ["<leader>j"] = { "<cmd> lua vim.diagnostic.goto_next() <CR>", "go to next diagnostic" },
    ["<leader>k"] = { "<cmd> lua vim.diagnostic.goto_prev() <CR>", "go to previous diagnostic" },
    ["<leader>bo"] = { "<cmd> %bd|e#|bd# <CR>", "BufOnly", opts = { noremap = true, silent = true } }
  },
}

-- more keybinds!

return M
