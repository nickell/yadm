-- vim: foldmethod=marker: foldlevel=0:

-- {{{ requires and functions
local tel_builtins = require 'telescope.builtin'
local tel_ext = require('telescope').extensions

local M = {}

local opts = { noremap = true, silent = true }

local function map(mode, key, command, options)
  options = options or opts
  vim.keymap.set(mode, key, command, options)
end

local function nmap(key, command, options) map('n', key, command, options) end

local function vmap(key, command, options) map('v', key, command, options) end

M.nmap = nmap
M.vmap = vmap
M.opts = opts

local initial_normal_opts = { initial_mode = 'normal', default_selection_index = 2 }

local function add_missing_imports()
  vim.lsp.buf.code_action { context = { only = { 'source.addMissingImports' } }, apply = true }
end

local function organize_imports()
  vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
end

--  {{{ Unused but saving
-- inoremap <A-j> <Esc>:m .+1<CR>==gi
-- inoremap <A-k> <Esc>:m .-2<CR>==gi
--  }}}
-- }}}

vim.g.mapleader = ' '

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
nmap('<Leader>a', tel_builtins.live_grep)
nmap('<Leader>bo', ':%bd|e#|bd#<CR>')
nmap('<Leader>dc', ':DiffviewClose<CR>')
nmap('<Leader>df', ':DiffviewFileHistory %<CR>')
nmap('<Leader>dl', ':DiffviewFileHistory<CR>')
nmap('<Leader>do', ':DiffviewOpen<CR>')
nmap('<Leader>e', vim.diagnostic.open_float)
nmap('<Leader>f', tel_builtins.find_files)
nmap('<Leader>gb', function() tel_builtins.git_branches(initial_normal_opts) end)
nmap('<Leader>gc', function() tel_builtins.git_commits(initial_normal_opts) end)
nmap('<Leader>gs', ':Git<CR>')
nmap('<Leader>h', '<Plug>RestNvim', { silent = true })
nmap('<Leader>j', vim.diagnostic.goto_next)
nmap('<Leader>k', vim.diagnostic.goto_prev)
nmap('<Leader>q', vim.diagnostic.setloclist)
nmap('<Leader>rw', function() tel_builtins.live_grep { default_text = vim.fn.expand '<cword>' } end)
nmap('<Leader>s', function() require('luasnip.loaders').edit_snippet_files() end)
nmap('<Leader>w', ':write<CR>')
nmap('<Leader>x', ':bd<CR>')
nmap('<leader><leader>s', '<cmd>source ~/.config/nvim/lua/my_luasnip.lua<CR>')
nmap('QQ', ':quit<CR>')
nmap('X', ':bd<CR>')
nmap('gd', ':bd<CR>')
nmap('gn', ':bn<CR>')
nmap('gp', ':bp<CR>')

map('t', '<M-o>', '<C-\\><C-n>:RnvimrToggle<CR>')
map('t', '<M-i>', '<C-\\><C-n>:RnvimrResize<CR>')

vim.cmd [[
" nnoremap <silent> <M-o> :RnvimrToggle<CR>
" tnoremap <silent> <M-i> <C-\><C-n>:RnvimrResize<CR>
" tnoremap <silent> <M-o> <C-\><C-n>:RnvimrToggle<CR>
let g:rnvimr_enable_picker = 1
let g:rnvimr_enable_bw = 1
" let g:rnvimr_enable_ex = 1
" g:rnvimr_vanilla
  ]]

vmap('<', '<gv')
vmap('<A-j>', ":m '>+1<CR>gv=gv")
vmap('<A-k>', ":m '<-2<CR>gv=gv")
vmap('>', '>gv')

M.cmp = function(cmp, ls)
  -- {{{ functions
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
  end

  local expand_or_jump = function(fallback)
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    else
      fallback()
    end
  end

  local cycle_completion = function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end

  local cycle_completion_back = function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end

  local luasnip_change_choice = function()
    if ls.choice_active() then ls.change_choice(1) end
  end
  -- }}}

  return cmp.mapping.preset.insert {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping(expand_or_jump, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
    ['<S-Tab>'] = cmp.mapping(cycle_completion_back, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(cycle_completion, { 'i', 's' }),
    ['<C-l'] = cmp.mapping(luasnip_change_choice, { 'i', 's' }),
  }
end

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
  nmap('[c', params.prev_hunk, _opts)
  nmap(']c', params.next_hunk, _opts)

  --  {{{ unused
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
  --  }}}
end

return M
