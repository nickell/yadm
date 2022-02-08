# vim: set fdm=marker fmr={{{,}}} fdl=0 ft=zsh:

# Used in ranger
export TERMCMD='alacritty'

# Used in git aliases for code reviews
export REVIEW_BASE='master'

# Make escape work immediately
export KEYTIMEOUT=1

# Pager use less
export PAGER="less -S"

# Set up ripgrep as fzf's backend
export FZF_DEFAULT_OPTS='--bind alt-j:down,alt-k:up'
export FZF_TMUX=1

export DOTFILES="$HOME/.dotfiles"

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
