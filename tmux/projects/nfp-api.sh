#!/usr/bin/env bash

SESSION="nfp-api"
ROOT="$HOME/devspace/nfp-api/develop"

if tmux has-session -t "=$SESSION" 2>/dev/null; then
  tmux switch-client -t "=$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -c "$ROOT"

tmux set-environment -t "$SESSION" DATASOURCE_USERNAME "tester01"
tmux set-environment -t "$SESSION" DATASOURCE_PASSWORD "Testing123!"

tmux new-window -t "$SESSION" -c "$ROOT"
tmux send-keys -t "$SESSION" "mvn spring-boot:run" Enter

tmux new-window -t "$SESSION" -n "nvim" -c "$ROOT"
tmux send-keys -t "$SESSION" "nvim ." Enter

tmux new-window -t "$SESSION" -c "$ROOT"

tmux switch-client -t "$SESSION"
