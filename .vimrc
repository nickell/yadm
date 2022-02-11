let g:configDir = $HOME . '/.vim'

" {{{ Plugins and config
filetype off

call plug#begin(g:configDir.'/plugged')
    source $HOME/.dotfiles/vim/plugins.vimrc
call plug#end()

source $HOME/.config/nvim/general.vimrc

set autoread
" }}}
