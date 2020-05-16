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
alias startx="ssh-agent startx"
alias cal="cal -m"
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
alias lx="ls -lXB"         #  Sort by extension.
alias lk="ls -lSr"         #  Sort by size, biggest last.
alias lt="ls -ltr"         #  Sort by date, most recent last.
alias lc="ls -ltcr"        #  Sort by/show change time,most recent last.
alias lu="ls -ltur"        #  Sort by/show access time,most recent last.

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
alias cam='mpv av://v4l2:/dev/video0'	# use mpv to show webcam

# git bare repo for dotfiles, see: https://www.atlassian.com/git/tutorials/dotfiles
alias dotfiles='/usr/bin/git --git-dir=/home/jerry/.dotfiles/ --work-tree=/home/jerry'

#------------------------------------------------------------
# Typos
#-----------------------------------------------------------
alias sytemctl="systemctl"

# }}}

# Functions {{{

gosnips() {
	rg --no-heading --no-filename --no-line-number ^snippet ~/.vim/UltiSnips/go.snippets ~/.vim/plugged/govim/UltiSnips/go.snippets | awk 'BEGIN{FS="\""} {printf("%-20s-%s%s\n", $1, $2, $3)}' | column
}

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

# The today todo list (vimwiki style).
# usage: tdy [category] - default category: work
function tdy() 
{
	category=${1:-work}
	tdy_folder="${TDY_PATH}/${category}"
	tdy_current_file="${tdy_folder}/$(date +'%Y/%m/%Y.%m.%d').wiki"
	tdy_current_folder="${tdy_current_file%/*}"
	tdy_previous_file=$(find "$tdy_folder" -type f | sort -nr | head -n1)

	mkdir -p "${tdy_current_folder}"

	if [[ ! -f "$tdy_current_file" ]]; then
		# Replace the path and '.wiki' with equal signs
		printf '%s\n' "= $(date +'%Y.%m.%d') =" >> "$tdy_current_file"
		if [[ -f "$tdy_previous_file" ]]; then
			# add not done items to the new file
			grep --invert-match '\- \[X\]' "$tdy_previous_file" >> "$tdy_current_file"
		fi
	fi

	if [[ -t 1 ]]; then
		"$EDITOR" "${tdy_current_file}"
	else
		# We're in a pipe, so let's cat this instead
		cat "${tdy_current_file}"
	fi
}

# takes number of hours and minutes + message and notifies you
function timer() 
{ 
	time_string=$1
	if [[ "$time_string" =~ ^[0-9]+[:][0-9]+$ ]]; then
		hours=${time_string/:*/}
		minutes=${time_string/*:/}
		seconds=$(( ( (hours * 60) + minutes ) * 60 ))
		time_hm="${hours}h:${minutes}m"
	elif [[ "$time_string" =~ ^[0-9]+$ ]]; then
		seconds=$(( time_string * 60 ))
		time_hm="${time_string}m"
	else
		printf '%s' "error: $time_string is not a number" >&2; return 1
	fi

	shift
	message=$*
	if [[ -z "$message" ]]; then
		printf '%s' "error: need a message as well" >&2; return 1
	fi

	notify-send "Timer: $message" "Waiting for ${time_hm}"
	(nohup sleep "$seconds" &> /dev/null && notify-send "Timer: $message" "${time_hm} has passed" &)
}

# }}}

# load common aliasses and functions.
source ~/.bash_common
