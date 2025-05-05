#!/bin/bash

user_resources=$HOME/.Xresources
user_modmap=$HOME/.Xmodmap
system_resources=/etc/X11/xinit/.Xresources
system_modmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $system_resources ]; then
	xrdb -merge $system_resources
fi

if [ -f $system_modmap ]; then
	xmodmap $system_modmap
fi

if [ -f "$user_resources" ]; then
	xrdb -merge "$user_resources"

fi

if [ -f "$user_modmap" ]; then
	xmodmap "$user_modmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi
