local M = {}

M.treesitter = {
  ensure_installed = {
    "c",
    "css",
    "dockerfile",
    "git_rebase",
    "gitattributes",
    "gitignore",
    "graphql",
    "html",
    "json",
    "lua",
    "markdown",
    "sql",
    "typescript",
    "vim",
    "yaml",
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",
    "vim-language-server",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "json-lsp",
    "prettierd",
    "prisma-language-server",
    "sql-formatter",
    "tailwindcss-language-server",
    "terraform-ls",
    "typescript-language-server",

    -- shell
    "bash-language-server",
    "shellcheck",
    "shfmt",

    -- generic
    "markdownlint",
    "xmlformatter",
    "yaml-language-server",
    "yamlfmt",
    "yamllint",
  },
}



-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
