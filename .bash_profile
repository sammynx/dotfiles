#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
PATH="${PATH}:$HOME/bin:$HOME/go/bin"

export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export EDITOR=vim
export SYSTEMD_EDITOR=vim
export SUDO_EDITOR=vim
export MANPAGER='less -s -M +Gg'

# tdy (today's todo list) path for tdy()
export TDY_PATH=$HOME/vimwiki/tdy

export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

alias startx='ssh-agent startx'

# if [ -z $DISPLAY ] && [ "$(tty)" == "/dev/tty1" ]; then
#   exec sway
# fi
