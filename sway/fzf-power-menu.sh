#!/usr/bin/env bash

case $(printf " lock\n shutdown\n reboot\n" | fzf) in
  " lock")
    swaylock -f
    ;;
  " shutdown")
    systemctl shutdown
    ;;
  " reboot")
    reboot
    ;;
  *)
    echo "Fix this script..........embarrassing....."
    ;;
esac
