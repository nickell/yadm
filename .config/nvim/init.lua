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

require('lazy').setup('plugins', { change_detection = {
  enabled = true,
  notify = false,
} })

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
o.sessionoptions = 'blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions'
o.undofile = true
o.undolevels = 100

o.foldcolumn = '1'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

o.backupdir = vim.fn.expand '~/.config/nvim/backup/'
o.directory = vim.fn.expand '~/.config/nvim/swap/'
o.undodir = vim.fn.expand '~/.config/nvim/undo/'

-- Make DiffView look cool
o.fillchars:append { diff = '╱' }
-- o.fillchars = {
--   fold = ' ',
--   diff = '╱',
--   wbr = '─',
--   msgsep = '─',
--   horiz = ' ',
--   horizup = '│',
--   horizdown = '│',
--   vertright = '│',
--   vertleft = '│',
--   verthoriz = '│',
-- }

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
nmap('<C-h>', '<CMD>NavigatorLeft<CR>')
nmap('<C-j>', '<CMD>NavigatorDown<CR>')
nmap('<C-k>', '<CMD>NavigatorUp<CR>')
nmap('<C-l>', '<CMD>NavigatorRight<CR>')
nmap('<CR>', 'i<CR><ESC>')
nmap('<Leader><CR>', ':noh<CR>')
nmap('<Leader>bo', ':%bd|e#|bd#<CR>')
nmap('<Leader>df', ':DiffviewFileHistory %<CR>')
nmap('<Leader>dl', ':DiffviewFileHistory<CR>')
-- nmap('<Leader>e', vim.diagnostic.open_float)
nmap('<Leader>j', vim.diagnostic.goto_next)
nmap('<Leader>k', vim.diagnostic.goto_prev)
nmap('<Leader>q', vim.diagnostic.setloclist)
-- nmap('<Leader>s', function() require('luasnip.loaders').edit_snippet_files() end)
nmap('<leader>sv', '<C-w>v', { desc = 'Split window vertically' }) -- split window vertically
nmap('<leader>sh', '<C-w>s', { desc = 'Split window horizontally' }) -- split window horizontally
nmap('<leader>se', '<C-w>=', { desc = 'Make splits equal size' }) -- make split windows equal width & height
nmap('<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' }) -- close current split window
nmap('<Leader>w', ':write<CR>')
nmap('<Leader>x', ':bd<CR>')
-- nmap('<leader><leader>s', '<cmd>source ~/.config/nvim/lua/my_luasnip.lua<CR>')
nmap('L', 'zO')
nmap('H', 'zC')
nmap('zL', 'L')
nmap('zH', 'H')
nmap('QQ', ':quit<CR>')
nmap('X', ':bd<CR>')
-- nmap('gd', ':bd<CR>')
nmap('gd', '<Plug>Kwbd')
nmap('gn', ':bn<CR>')
nmap('gp', ':bp<CR>')

vmap('<', '<gv')
vmap('<A-j>', ":m '>+1<CR>gv=gv")
vmap('<A-k>', ":m '<-2<CR>gv=gv")
vmap('>', '>gv')

vim.cmd [[
"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(&modified)
      let answer = confirm("This buffer has been modified.  Are you sure you want to delete it?", "&Yes\n&No", 2)
      if(answer != 1)
        return
      endif
    endif
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>
]]
