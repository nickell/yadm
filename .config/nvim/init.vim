let g:configDir = $HOME . '/.config/nvim'

filetype off

call plug#begin(g:configDir.'/plugged')
    source $HOME/.config/nvim/plugins.vim
call plug#end()

source $HOME/.config/nvim/general.vim

set completeopt=noinsert,menuone,noselect

nnoremap <leader>rc :so  ~/.config/nvim/init.vim<cr>
