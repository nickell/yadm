-- vim: foldmethod=marker

-- {{{ requires and functions
local tel_builtins = require 'telescope.builtin'
local tel_ext = require('telescope').extensions

local M = {}

local opts = { noremap = true, silent = true }

local function nmap(key, command, options)
  options = options or opts
  vim.keymap.set('n', key, command, options)
end

M.nmap = nmap
M.opts = opts

local initial_normal_opts = { initial_mode = 'normal', default_selection_index = 2 }

local function file_browser_current_path()
  tel_ext.file_browser.file_browser {
    initial_mode = 'normal',
    path = vim.fn.expand '%:p:h',
    select_buffer = true,
  }
end
local function add_missing_imports()
  vim.lsp.buf.code_action { context = { only = { 'source.addMissingImports' } }, apply = true }
end
local function organize_imports()
  vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
end
-- }}}

vim.g.mapleader = ' '

nmap('-', 'dd')
nmap('<C-h>', '<CMD>NavigatorLeft<CR>')
nmap('<C-j>', '<CMD>NavigatorDown<CR>')
nmap('<C-k>', '<CMD>NavigatorUp<CR>')
nmap('<C-l>', '<CMD>NavigatorRight<CR>')
nmap('<C-n>', function() tel_ext.file_browser.file_browser(initial_normal_opts) end)
nmap('<CR>', 'i<CR><ESC>')
nmap('<Leader><CR>', ':noh<CR>')
nmap('<Leader>a', tel_builtins.live_grep)
nmap('<Leader>bo', ':%bd|e#|bd#<CR>')
nmap('<Leader>e', vim.diagnostic.open_float)
nmap('<Leader>f', tel_builtins.find_files)
nmap('<Leader>gc', function() tel_builtins.git_commits(initial_normal_opts) end)
nmap('<Leader>gb', function() tel_builtins.git_branches(initial_normal_opts) end)
nmap('<Leader>j', vim.diagnostic.goto_next)
nmap('<Leader>k', vim.diagnostic.goto_prev)
nmap('<Leader>n', file_browser_current_path)
nmap('<Leader>q', vim.diagnostic.setloclist)
nmap('<Leader>rw', function() tel_builtins.live_grep { default_text = vim.fn.expand '<cword>' } end)
nmap('<Leader>w', ':write<CR>')
nmap('<Leader>x', ':bd<CR>')
nmap('<S-Tab>', ':bp<CR>')
nmap('<Tab>', ':bn<CR>')
nmap('QQ', ':quit<CR>')

M.lsp = function(bufnr, lsp_formatting)
  local _opts = { noremap = true, silent = true, buffer = bufnr }
  nmap('<Leader>D', vim.lsp.buf.type_definition, _opts)
  nmap('<Leader>ca', vim.lsp.buf.code_action, _opts)
  nmap('<Leader>d', vim.lsp.buf.definition, _opts)
  nmap('<Leader>lr', vim.lsp.buf.references, _opts)
  nmap('<Leader>p', function() lsp_formatting(_opts.bufnr, true) end, _opts)
  nmap('<Leader>rn', vim.lsp.buf.rename, _opts)
  nmap('K', vim.lsp.buf.hover, _opts)
  nmap('gD', vim.lsp.buf.declaration, _opts)
  nmap('gi', vim.lsp.buf.implementation, _opts)
end

M.tsserver = function(bufnr)
  local _opts = { noremap = true, silent = true, buffer = bufnr }
  nmap('<Leader>ti', add_missing_imports, _opts)
  nmap('<Leader>to', organize_imports, _opts)
end

M.git = function(params)
  local _opts = { expr = true, buffer = params.bufnr }
  local gs = package.loaded.gitsigns
  nmap('<leader>gb', function() gs.blame_line { full = true } end, {})
  nmap(']c', params.next_hunk, _opts)
  nmap('[c', params.prev_hunk, _opts)

  -- Actions
  -- map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
  -- map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
  -- map('n', '<leader>hS', gs.stage_buffer)
  -- map('n', '<leader>hu', gs.undo_stage_hunk)
  -- map('n', '<leader>hR', gs.reset_buffer)
  -- map('n', '<leader>hp', gs.preview_hunk)
  -- map('n', '<leader>hd', gs.diffthis)
  -- map('n', '<leader>hD', function()
  --   gs.diffthis '~'
  -- end)
  -- map('n', '<leader>td', gs.toggle_deleted)

  -- Text object
  -- map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

return M
