#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1='[\u@\h \W]\$ '
#return value visualisation.
reset="$(tput sgr0)"
red="$(tput setaf 1)"
blue="$(tput setaf 12)"
green="$(tput setaf 2)"
yellow="$(tput setaf 11)"
bold="$(tput bold)"
PS1="\$? \[$bold\]\$(if [[ \${EUID} == 0 ]]; then echo \"\[$red\]\h\"; else echo \"\[$yellow\]\u@\h\"; fi)\[$blue\] \w \$\[$reset\] "

# History
shopt -s histappend
shopt -s cmdhist
HISTSIZE=9999
HISTIGNORE="!*"
HISTTIMEFORMAT="%d/%m/%y %T "
HISTCONTROL=ignorespace
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export MANPAGER='less -s -M +Gg'

# History completion
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# sudo tab completion
complete -cf sudo

complete -c man which

# if type only path, cd to path
shopt -s autocd

# Automatically fix directory name typos when changing directory.
shopt -s cdspell

shopt -s extglob

# Enable history expansion with the SPACE key.
bind Space:magic-space

FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!.snapshots/*"'

# Alias {{{

#----------------------------------------------------------
# Modified commands
#----------------------------------------------------------
alias du="du -h"
alias cal="cal -m"
alias grep="grep --color=auto "
alias mkdir="mkdir -p -v"
alias rm="rm -Iv --one-file-system"
alias cp="cp -v --reflink=auto "
alias mv="mv -v"
alias df="df -kTh"
alias feh="feh --scale-down --draw-exif"
# forgot sudo!
alias cmon='cmd="$(fc -ln -1)"; sudo $cmd'
# open vim with a file selected in filechooser.
alias vimf='file=$(fzf --preview "bat --line-range :80 --color always {}"); pushd $(dirname $file) > /dev/null; vim $(basename $file); popd > /dev/null'
# restore a previously saved session.
alias vims='vim -S Session.vim'

# make sudo see aliasses
alias sudo='sudo '

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls="ls -h --color "
alias lx="ls -lXB"         #  Sort by extension.
alias lk="ls -lSr"         #  Sort by size, biggest last.
alias lt="ls -ltr"         #  Sort by date, most recent last.
alias lc="ls -ltcr"        #  Sort by/show change time,most recent last.
alias lu="ls -ltur"        #  Sort by/show access time,most recent last.

alias ll="ls -ltvL --group-directories-first "
alias la="ll -A"           #  Show hidden files.

#-------------------------------------------------------------
# Fun aliases
#-------------------------------------------------------------
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"

#----------------------------------------------------------
# New commands
#----------------------------------------------------------
alias psg="ps aux | grep -v grep | grep -e VSZ -i -e"
alias weather='curl -m 10 http://wttr.in/uithoorn'
alias moon='curl -m 10 http://wttr.in/Moon'
alias bundlesupdate='cd ~/.vim/bundle; for bundle in * ; do if [[ -d "$bundle/.git" ]]; then echo "Bundle: $bundle..."; cd "$bundle"; git pull; cd ..; fi done'
alias cam='mpv av://v4l2:/dev/video0'	# use mpv to show webcam
alias config='/usr/bin/git --git-dir=/home/jerry/.dotfiles/ --work-tree=/home/jerry'
#alias i3-keys='rg --no-line-number ^bindsym\ $HOME/.config/i3/config | awk "{$1=""; print $0}" | fzf'

#------------------------------------------------------------
# Typos
#-----------------------------------------------------------
alias sytemctl="systemctl"

# }}}

# Functions {{{

# Color man pages
man() {
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;33m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;37m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;37m' \
    command man "$@"
}

#Change dir and list it
cl() {
    local dir="$1"
	local dir="${dir:=$HOME}"
    if [[ -d "$dir" ]]; then
        cd "$dir" > /dev/null; ll
    else
        echo "::Bash cl: $dir: Directory not found"
    fi
}

# Make dirictory and move to it.
mcd() {
	mkdir $1
	cd $1
}

function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1 ;;
            *.tar.gz)    tar xvzf $1 ;;
            *.bz2)       bunzip2 $1 ;;
            *.rar)       unrar x $1 ;;
            *.gz)        gunzip $1 ;;
            *.tar)       tar xvf $1 ;;
            *.tbz2)      tar xvjf $1 ;;
            *.tgz)       tar xvzf $1 ;;
            *.zip)       unzip $1 ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z x $1 ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# }}}
