#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here).

# Disable DPMS turning off the screen
# xset -dpms
# xset s off

# Disable bell
# xset -b

# euro-sign and Enable zapping (C-A-<Bksp> kills X)
setxkbmap -option eurosign:5 -option lv3 us

userresources=$XDG_CONFIG_HOME/X11/Xresources
usermodmap=$XDG_CONFIG_HOME/X11/Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

[[ -f $sysresources ]] && xrdb -merge $sysresources

[[ -f $sysmodmap ]] && xmodmap $sysmodmap

[[ -f "$userresources" ]] && xrdb -merge "$userresources"

[[ -f "$usermodmap" ]] && xmodmap "$usermodmap"

# Make sure this is before the 'exec' command or it won't be sourced.
[[ -f /etc/xprofile ]] && source /etc/xprofile

[[ -f ~/.xprofile ]] && source ~/.xprofile

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# make CAPS_LOCK an ESC key
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

devmon --no-gui &                   # udiskie replacement without dependencys, polkit etc.
sh .fehbg &                         # sets background image
/usr/bin/dunst &
[[ -f $HOME/bin/bat-low-warning ]] && $HOME/bin/bat-low-warning &    # Low battery notifications

# start WM and enable WM logging
exec /usr/bin/i3 -V > ~/.config/i3/i3.log
