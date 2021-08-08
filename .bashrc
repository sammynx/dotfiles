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
PS1="\[\e]2;\$PWD\a\]\$? \[$bold\]\$(if [[ \${EUID} == 0 ]]; then echo \"\[$red\]\h\"; else echo \"\[$yellow\]\u@\h\"; fi)\[$blue\] \w \$\[$reset\] "

# History
shopt -s histappend
shopt -s cmdhist
HISTSIZE=9999
HISTIGNORE="!*"
HISTTIMEFORMAT="%d/%m/%y %T "
HISTCONTROL=ignorespace
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r;"
# set window title.
# PROMPT_COMMAND+="printf '\033]2;%s\033\\' '${PWD}';"
# emit OSC 7 to open new terminal at current directory.
PROMPT_COMMAND+='printf "\033]7;file://%s%s\033\\" "${HOSTNAME}" "${PWD}";'

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

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# load common aliasses and functions.
source ~/.bash_aliasses

# forgit
source /usr/share/zsh/plugins/forgit-git/forgit.plugin.zsh

# Functions {{{

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
	mkdir $1 && cd $1
}

# Handy Extract Program
function extract()
{
	(($#)) || return

	if [[ ! -r $1 ]]; then
            echo "$0: file is unreadable: \`$1'" >&2
            return 1
    fi

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
		*.xz)        unxz $1 ;;
		*)           echo "$0: unrecognized file extension: '$1'" >&2
					 return 1 ;;
	esac

	return $?
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

# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# }}}
