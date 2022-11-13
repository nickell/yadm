local o = vim.opt

o.clipboard = 'unnamedplus'
o.number = true
o.relativenumber = true
o.ignorecase = true
o.wildignorecase = true
o.smartcase = true
o.termguicolors = true
o.autoindent = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true

o.undofile = true
o.history = 100
o.undolevels = 100

o.foldmethod = 'expr'
-- o.foldexpr = 'nvim_treesitter#foldexpr()'
-- o.foldenable = false

o.undodir = vim.fn.expand '~/.config/nvim/undo/'
o.backupdir = vim.fn.expand '~/.config/nvim/backup/'
o.directory = vim.fn.expand '~/.config/nvim/swap/'
