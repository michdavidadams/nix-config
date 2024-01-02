#!/usr/bin/env bash

case $(printf " lock\n shutdown\n reboot\n" | fzf) in
  " lock")
    swaylock -f
    ;;
  " shutdown")
    shutdown
    ;;
  " reboot")
    reboot
    ;;
  *)
    echo "Fix this script..........embarrassing....."
    ;;
esac
