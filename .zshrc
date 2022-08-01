# vim: set fdm=marker fmr={{{,}}} fdl=0:

# {{{ ZSH Settings
HISTFILE=~/.histfile
HISTSIZE=999999
SAVEHIST=999999
setopt appendhistory autocd extendedglob nomatch hist_ignore_all_dups
unsetopt beep
setopt NO_NOMATCH
# }}}

# {{{ Prezto
# Source Prezto and remove an alias from it
[ -f $HOME/.zprezto/init.zsh ] && source $HOME/.zprezto/init.zsh
unalias rm
# }}}

# {{{ Prompt
# Change prompt for inside ranger
if [ -n "$RANGER_LEVEL" ]; then export PS1="[R] $PS1"; fi
# }}}

# {{{ FZF direnv nvm rvm
# {{{ FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Make ctrl-s work for reverse-i-search/i-search, from here: https://stackoverflow.com/a/25391867/870835
[[ $- == *i* ]] && stty -ixon
# }}}

# {{{  direnv
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
fi
# }}}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# source /usr/share/nvm/init-nvm.sh
# }}}

# {{{ Dotfiles
# Set up aliases and functions
source $HOME/.aliases.zsh
source $HOME/.functions.zsh
# }}}

# Support local modifications
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
