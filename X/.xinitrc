#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

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
redshift -l 51.50853:-0.12574 &
dunst &
xrandr --output DP-1 --rotate normal --auto --output DVI-1-0 --rotate right --right-of DP-1 --auto --output DP-2 --left-of DP-1 --auto
feh --bg-center /home/ymherklotz/images/wp1.jpg /home/ymherklotz/images/wp3.jpg /home/ymherklotz/images/wp2.jpg
xsetroot -cursor_name left_ptr

#exec i3
exec bspwm
