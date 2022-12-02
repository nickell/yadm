#!/usr/bin/env zsh

sleep 0.1;

dir=$1;
session=${$(basename $1)//./};

# Check if the session exists, discarding output
# We can check $? for the exit status (zero for success, non-zero for failure)
tmux has-session -t $session 2>/dev/null

if [ $? != 0 ]; then
  tmux new-session -d -s $session;
  tmux send-keys -t $session.0 cd SPACE $dir ENTER nvim ENTER;
fi

# Attach to created session
tmux attach-session -t $session
