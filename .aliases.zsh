# vim: set ft=sh:

alias -- -="popd"
alias a="cal"
alias aria="aria2c"
alias au="sudo pacman -Syu"
alias bm="bookmark"
alias c="clear"
alias ctl="systemctl --user"
alias copy-png="xclip -selection clipboard -t image/png -i"
alias d="sudo docker"
alias dc="sudo docker-compose"
alias e="${(z)VISUAL:-${(z)EDITOR}}"
alias g="git"
alias gd="git diff"
alias gl="git log"
alias gs="git status"
alias j="jump"
alias ll="ls -aFhl"
alias m="make"
alias mosh='TERM=xterm-256color mosh'
alias nr="npm run"
alias nrs="npm run --silent"
alias p="sudo pacman --assume-installed nodejs=${NODE_VERSION}-1"
alias pg="pgcli -D"
alias pgl="pgcli -D local"
alias publicip="curl ipecho.net/plain;echo"
alias r="ranger"
alias ranm="rm -rf node_modules && rnm && rm yarn.lock"
alias rc="source ranger"
alias remove-lib="find . -name 'lib' -type d -prune -exec rm -rf '{}' +"
alias remove-node-modules="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +"
alias remove-tsbuildinfo"find . -name 'tsconfig.tsbuildinfo' -type f -prune -exec rm -rf '{}' +"
alias rs="ctl restart"
alias sctl="sudo systemctl"
alias se="sudoedit"
alias show-cursor='echo "\x1B[?25h"'
alias sql-prod="psql -h yaguara-web-production.cv360oyfmcuy.us-east-2.rds.amazonaws.com -d yaguara -U i8jEDBevToM"
alias sql-staging="psql -h yaguara-web-staging.cv360oyfmcuy.us-east-2.rds.amazonaws.com -d yaguara -U tWrn2DKUyri"
alias sql-test="psql -h localhost -d test -U postgres"
alias sql="psql -h localhost -d yaguara -U postgres"
alias ssh='TERM=xterm-256color ssh'
alias ssha='TERM=alacritty ssh'
alias tf="terraform"
alias tm="tmux"
alias tmn="tmux new -s main"
alias v="vim"
alias vu="nvim +PlugUpgrade +PlugUpdate"
alias x='exit'
alias y="yarn"
alias ya="yadm"
alias ystart="systemctl --user start app"
alias ystop="systemctl --user stop app"
alias z='fasd_cd -d'

# Functions
logs () {
    journalctl --user -f -o cat -u $1 | bunyan -o short
}

rn () {
    tmux split-window -h
    tmux send-keys 'ranger' Enter
}

t () {
    tmux split-window -v -p 9 \; last-pane \; split-window -v -p 9 \; \
        last-pane \; split-window -v -p 9 \; last-pane \; split-window -v -p 9 \; \
        last-pane \; split-window -v -p 9 \; last-pane \; split-window -v -p 9 \; \
        last-pane \; split-window -v -p 9 \; last-pane \; split-window -v -p 9 \; \
        last-pane \; select-layout tiled

    tmux select-pane -t:.8
    tmux send-keys -t:.0 'logs front-end' Enter
    tmux send-keys -t:.1 'logs api' Enter
    tmux send-keys -t:.2 'logs api-watch' Enter
    tmux send-keys -t:.4 'logs etl' Enter
    tmux send-keys -t:.5 'logs websockets' Enter
    tmux send-keys -t:.6 'logs mailer' Enter
    tmux send-keys -t:.7 'logs cronjobs' Enter
}

n () {
    if [ $# -eq 0 ]
    then
        nordvpn status;
    else
        nordvpn $*;
    fi
}
