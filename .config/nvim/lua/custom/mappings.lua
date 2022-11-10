local M = {}

M.general = {
  i = {
    ["<C-l>"] = { "<ESC><cmd> lua vim.lsp.buf.code_action() <CR>", "run lsp code_action" },
  },

  n = {
    -- My tweaks
    ["-"] = { "dd", "delete line" },
    ["<CR>"] = { "i<cr><esc>", "enter to add line in normal mode" },
    ["<leader><CR>"] = { "<cmd> noh <CR>", "noh", opts = { noremap = true, silent = true } },
    ["<leader>bo"] = { "<cmd> %bd|e#|bd# <CR>", "BufOnly", opts = { noremap = true, silent = true } },
    ["<leader>w"] = { "<cmd> w <CR>", "write file" },
    ["QQ"] = { "<cmd> q <CR>", "quit vim" },

    -- lsp
    ["<C-l>"] = {
      function()
        vim.lsp.buf.code_action {
          context = {
            only = { "source.addMissingImports" },
          },
          apply = true,
        }
      end,
      "run code_action",
    },
    ["<leader>to"] = {
      function()
        vim.lsp.buf.code_action {
          context = {
            only = { "source.organizeImports" },
          },
          apply = true,
        }
      end,
      "run code_action",
    },

    ["<leader>j"] = { "<cmd> lua vim.diagnostic.goto_next() <CR>", "go to next diagnostic" },
    ["<leader>k"] = { "<cmd> lua vim.diagnostic.goto_prev() <CR>", "go to previous diagnostic" },
    ["<leader>p"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "lsp formatting",
    },

    -- Telescope
    ["<leader>f"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>a"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>ta"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>tb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>th"] = { "<cmd> Telescope help_tags <CR>", "help page" },
  },
}

M.disabled = {
  n = {
    ["<leader>f"] = "",
    ["<leader>fa"] = "",
    ["<leader>fb"] = "",
    ["<leader>ff"] = "",
    ["<leader>fh"] = "",
    ["<leader>fm"] = "",
    ["<leader>fo"] = "",
    ["<leader>fw"] = "",
    ["<leader>h"] = "",
    ["<leader>pt"] = "",
    ["<leader>v"] = "",
  },
}

return M
