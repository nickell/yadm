# vim: set fdm=marker fmr={{{,}}} fdl=0 ft=zsh:

# {{{ PATH
# Node 14.15.4
# path+=$HOME/.nvm/versions/node/v14.15.4/bin
# export NODE_VERSION=14.15.4
# path+=$HOME/.nvm/versions/node/v16.13.1/bin
# export NODE_VERSION=16.13.1
path=($HOME/.nvm/versions/node/v16.15.0/bin $path)
export NODE_VERSION=16.15.0

# YVM
# export YVM_DIR=/home/chad/.yvm
# [ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh
path+=$HOME/.yvm/versions/v1.22.4/bin

# Yarn
path+=$HOME/.yarn/bin

path+=$HOME/.bin
path+=$HOME/.local/bin

export PATH
# }}}

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
