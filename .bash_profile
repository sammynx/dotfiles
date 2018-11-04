#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
PATH="${PATH}:$HOME/bin:$HOME/go/bin"

export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
