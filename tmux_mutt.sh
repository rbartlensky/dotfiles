#!/bin/sh

if tmux has-session -t mutt ; then
    tmux attach -t mutt
else
    tmux \
        new-session -s mutt  "mutt ; read" \; \
        split-window "mutt -e \"source ~/.mutt/account-outlook-kcl\" ; read" \; \
        select-layout even-vertical
fi
