#!/usr/bin/env bash

password=$(find ~/.password-store/ -type f -name '*.gpg' |
	sed 's/.*\/\(.*\)\.gpg$/\1/' | bemenu $@ )
[ -n "$password" ] && pass show -c "$password"

