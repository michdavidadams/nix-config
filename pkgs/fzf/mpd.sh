#!/usr/bin/env bash
# fzf script for mpd + mpc

# Clears the queue if music is paused
if [ $(mpc status %state%) = 'paused' ]; do
  mpc clear
fi

# takes in argument, shows artists or songs
case $1 in
  artist)
    mpc ls | fzf | mpc add -- && mpc play
    ;;
  song)
    mpc listall | fzf | mpc add -- && mpc play
    ;;
  *)
    mpc ls | fzf | mpc add -- && mpc play
    ;;
esac
