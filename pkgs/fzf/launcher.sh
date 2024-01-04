#!/usr/bin/env bash
j4-dmenu-desktop --dmenu=fzf --no-generic --no-exec | xargs swaymsg exec --
