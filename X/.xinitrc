#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xset r rate 200 30

# Startup programs
eval $(ssh-agent)
sxhkd &
compton &
redshift &
dunst &
wal -R
# xrandr --output DP-1 --auto --output DP-2 --left-of DP-1 --auto --output DVI-1-0 --rotate left --right-of DP-1 --auto
feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"
xsetroot -cursor_name left_ptr

#exec i3
exec bspwm
