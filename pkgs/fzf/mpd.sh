#!/usr/bin/env bash

mpc clear && mpc ls | fzf | mpc add -- && mpc play
