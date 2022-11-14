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
nmap('<Leader>dc', ':DiffviewClose<CR>')
nmap('<Leader>df', ':DiffviewFileHistory %<CR>')
nmap('<Leader>dl', ':DiffviewFileHistory<CR>')
nmap('<Leader>do', ':DiffviewOpen<CR>')
nmap('<Leader>e', vim.diagnostic.open_float)
nmap('<Leader>f', tel_builtins.find_files)
nmap('<Leader>gb', function() tel_builtins.git_branches(initial_normal_opts) end)
nmap('<Leader>gc', function() tel_builtins.git_commits(initial_normal_opts) end)
nmap('<Leader>j', vim.diagnostic.goto_next)
nmap('<Leader>k', vim.diagnostic.goto_prev)
nmap('<Leader>n', file_browser_current_path)
nmap('<Leader>q', vim.diagnostic.setloclist)
nmap('<Leader>rw', function() tel_builtins.live_grep { default_text = vim.fn.expand '<cword>' } end)
nmap('<Leader>w', ':write<CR>')
nmap('<Leader>x', ':bd<CR>')
nmap('QQ', ':quit<CR>')
nmap('gn', ':bn<CR>')
nmap('gp', ':bp<CR>')

M.cmp = function(cmp, ls)
  -- {{{ has_words_before
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
  end
  -- }}}

  return cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<C-k>'] = cmp.mapping(function(fallback)
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif ls.expand_or_jumpable() then
        ls.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif ls.jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
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
