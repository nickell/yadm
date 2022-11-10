local tel_builtins = require 'telescope.builtin'
local tel_extensions = require('telescope').extensions

local M = {}

local opts = { noremap = true, silent = true }

local function mapn(key, command, options)
  options = options or opts
  vim.keymap.set('n', key, command, options)
end

M.mapn = mapn
M.opts = opts

local function ctrlN() tel_extensions.file_browser.file_browser { initial_mode = 'normal', default_selection_index = 2 } end
local function leaderN()
  tel_extensions.file_browser.file_browser { initial_mode = 'normal', default_selection_index = 2 }
end
local function leaderTi() vim.lsp.buf.code_action { context = { only = { 'source.addMissingImports' } }, apply = true } end
local function leaderTo() vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true } end

vim.g.mapleader = ' '

mapn('-', 'dd')
mapn('<C-h>', '<CMD>NavigatorLeft<CR>')
mapn('<C-j>', '<CMD>NavigatorDown<CR>')
mapn('<C-k>', '<CMD>NavigatorUp<CR>')
mapn('<C-l>', '<CMD>NavigatorRight<CR>')
mapn('<C-n>', ctrlN)
mapn('<CR>', 'i<CR><ESC>')
mapn('<Leader><CR>', ':noh<CR>')
mapn('<Leader>a', tel_builtins.live_grep)
mapn('<Leader>bo', ':%bd|e#|bd#<CR>')
mapn('<Leader>e', vim.diagnostic.open_float)
mapn('<Leader>f', tel_builtins.find_files)
mapn('<Leader>j', vim.diagnostic.goto_next)
mapn('<Leader>k', vim.diagnostic.goto_prev)
mapn('<Leader>n', leaderN)
mapn('<Leader>q', vim.diagnostic.setloclist)
mapn('<Leader>rw', function() tel_builtins.live_grep { default_text = vim.fn.expand '<cword>' } end)
mapn('<Leader>w', ':write<CR>')
mapn('<Leader>x', ':bd<CR>')
mapn('<S-Tab>', ':bp<CR>')
mapn('<Tab>', ':bn<CR>')
mapn('QQ', ':quit<CR>')

M.lsp = function(_opts, lsp_formatting)
  mapn('<C-k>', vim.lsp.buf.signature_help, _opts)
  mapn('<Leader>D', vim.lsp.buf.type_definition, _opts)
  mapn('<Leader>ca', vim.lsp.buf.code_action, _opts)
  mapn('<Leader>d', vim.lsp.buf.definition, _opts)
  mapn('<Leader>p', function() lsp_formatting(_opts.bufnr, true) end, _opts)
  mapn('<Leader>rn', vim.lsp.buf.rename, _opts)
  mapn('K', vim.lsp.buf.hover, _opts)
  mapn('gD', vim.lsp.buf.declaration, _opts)
  mapn('gi', vim.lsp.buf.implementation, _opts)
  mapn('gr', vim.lsp.buf.references, _opts)
end

M.tsserver = function(_opts)
  mapn('<Leader>ti', leaderTi, _opts)
  mapn('<Leader>to', leaderTo, _opts)
end

return M
