#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here).

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

export BROWSER=qutebrowser

# make CAPS_LOCK an ESC key
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

devmon --no-gui &                   # udiskie replacement without dependencys, polkit etc.
sh .fehbg &                         # sets background image
/usr/local/bin/bat_low_warning &    # Low battery notifications

exec /usr/bin/i3 -V > ~/.config/i3/i3.log  # start WM
