vim.g.mapleader = ' '

-- Useful for debugging
-- print(vim.inspect(variable))

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup 'plugins'

local o = vim.opt

o.autoindent = true
o.clipboard = 'unnamedplus'
o.expandtab = true
o.ignorecase = true
o.number = true
o.relativenumber = true
o.shiftwidth = 2
o.smartcase = true
o.softtabstop = 2
o.tabstop = 2
o.termguicolors = true
o.wildignorecase = true
o.wrap = false

o.backup = true
o.backupskip = '/tmp/*,/private/tmp/*'
o.swapfile = false
o.writebackup = true

o.history = 100
o.sessionoptions = 'blank,buffers,curdir,folds'
o.undofile = true
o.undolevels = 100

o.foldcolumn = '1'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

o.backupdir = vim.fn.expand '~/.config/nvim/backup/'
o.directory = vim.fn.expand '~/.config/nvim/swap/'
o.undodir = vim.fn.expand '~/.config/nvim/undo/'

local opts = { noremap = true, silent = true }

local function map(mode, key, command, options)
  options = options or opts
  vim.keymap.set(mode, key, command, options)
end

local function nmap(key, command, options) map('n', key, command, options) end

local function vmap(key, command, options) map('v', key, command, options) end

nmap('-', 'dd')
nmap('<A-j>', ':m .+1<CR>')
nmap('<A-k>', ':m .-2<CR>')
nmap('<A-o>', ':RnvimrToggle<CR>')
nmap('<C-h>', '<CMD>NavigatorLeft<CR>')
nmap('<C-j>', '<CMD>NavigatorDown<CR>')
nmap('<C-k>', '<CMD>NavigatorUp<CR>')
nmap('<C-l>', '<CMD>NavigatorRight<CR>')
nmap('<CR>', 'i<CR><ESC>')
nmap('<Leader><CR>', ':noh<CR>')
nmap('<Leader>bo', ':%bd|e#|bd#<CR>')
nmap('<Leader>dc', ':DiffviewClose<CR>')
nmap('<Leader>df', ':DiffviewFileHistory %<CR>')
nmap('<Leader>dl', ':DiffviewFileHistory<CR>')
nmap('<Leader>do', ':DiffviewOpen<CR>')
nmap('<Leader>e', vim.diagnostic.open_float)
nmap('<Leader>gs', ':Git<CR>')
nmap('<Leader>j', vim.diagnostic.goto_next)
nmap('<Leader>k', vim.diagnostic.goto_prev)
nmap('<Leader>q', vim.diagnostic.setloclist)
nmap('<Leader>s', function() require('luasnip.loaders').edit_snippet_files() end)
nmap('<Leader>w', ':write<CR>')
nmap('<Leader>x', ':bd<CR>')
nmap('<leader><leader>s', '<cmd>source ~/.config/nvim/lua/my_luasnip.lua<CR>')
nmap('L', 'zo')
nmap('H', 'zc')
nmap('zL', 'L')
nmap('zH', 'H')
nmap('QQ', ':quit<CR>')
nmap('X', ':bd<CR>')
nmap('gd', ':bd<CR>')
nmap('gn', ':bn<CR>')
nmap('gp', ':bp<CR>')

map('t', '<M-o>', '<C-\\><C-n>:RnvimrToggle<CR>')
map('t', '<M-i>', '<C-\\><C-n>:RnvimrResize<CR>')

vim.cmd [[
let g:rnvimr_enable_picker = 1
let g:rnvimr_enable_bw = 1
let g:rnvimr_layout = {
           \ 'relative': 'editor',
           \ 'width': &columns,
           \ 'height': &lines - 2,
           \ 'col': 0,
           \ 'row': 0,
           \ 'style': 'minimal'
           \ }
  ]]

vmap('<', '<gv')
vmap('<A-j>', ":m '>+1<CR>gv=gv")
vmap('<A-k>', ":m '<-2<CR>gv=gv")
vmap('>', '>gv')
