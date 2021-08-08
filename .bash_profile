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

# have firefox use wayland
export MOZ_ENABLE_WAYLAND=1

# seems to be neccesary  for screen sharing.
export XDG_CURRENT_DESKTOP=sway

# switch govim logging off.
export GOVIM_LOG=off

export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --info=inline --border --margin=1 --padding=1"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export PATH="$HOME/.cargo/bin:$PATH"
