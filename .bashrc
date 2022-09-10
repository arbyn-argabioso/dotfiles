# -------------------------------------------------------------------------+
# Git disable CRLF-LF checking, update bash prompt                         |
# -------------------------------------------------------------------------+

source ~/.bash_prompt

# -------------------------------------------------------------------------+
# Man pages                                                                |
# -------------------------------------------------------------------------+

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'

# -------------------------------------------------------------------------+
# Bash History                                                             |
# -------------------------------------------------------------------------+

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
export HISTTIMEFORMAT='%F %T '

# keep history up to date, across sessions, in realtime
# http://unix.stackexchange.com/a/48113
# No duplicate entries, but keep space-prefixed commands
export HISTCONTROL="ignoredups"

# Big big history (default is 500)
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE

# Append to history, don't overwrite it
type shopt &> /dev/null && shopt -s histappend

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Save multi-line commands as one command
shopt -s cmdhist

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ^ the only downside with this is [up] on the readline will go over all
# history not just this bash session.

# -------------------------------------------------------------------------+
# Aliases                                                                  |
# -------------------------------------------------------------------------+

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Verbose mv, rm, cp
alias mv='mv -v'
alias rm='rm -i -v'
alias cp='cp -v'

# Shorthand, renames, and typos
alias chmox='chmod -x'
alias brwe=brew

# Reload .bashrc
alias reload="source ~/.bashrc"

# Better ls commands
alias l="ls"

# -------------------------------------------------------------------------+
# Better `cd` -ing                                                         |
# -------------------------------------------------------------------------+

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell;

# Autocorrect on directory names to match a glob.
shopt -s dirspell 2> /dev/null

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# -------------------------------------------------------------------------+
# Functions                                                                |
# -------------------------------------------------------------------------+

# Create a new directory and enter it
function md() {
	mkdir -p "$@" && cd "$@"
}

# find shorthand
function f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# List all files, long format, colorized, permissions in octal
function la() {
 	ls -la --color "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract() {
	if [ -f "$1" ] ; then
		local filename=$(basename "$1")
		local foldername="${filename%%.*}"
		local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
		local didfolderexist=false
		if [ -d "$foldername" ]; then
			didfolderexist=true
			read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
			echo
			if [[ $REPLY =~ ^[Nn]$ ]]; then
				return
			fi
		fi
		mkdir -p "$foldername" && cd "$foldername"
		case $1 in
			*.tar.bz2) tar xjf "$fullpath" ;;
			*.tar.gz) tar xzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.tar) tar xf "$fullpath" ;;
			*.taz) tar xzf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xjf "$fullpath" ;;
			*.tgz) tar xzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.zip) unzip "$fullpath" ;;
			*) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# -------------------------------------------------------------------------+
# virtualenvwrapper setup                                                  |
# -------------------------------------------------------------------------+

export WORKON_HOME="/d/.virtualenvs"
export PROJECT_HOME="/d/.dev"
source ~/AppData/Local/Programs/Python/Python37/Scripts/virtualenvwrapper.sh

# -------------------------------------------------------------------------+
# Custom personal environment variables                                    |
# -------------------------------------------------------------------------+

export PYTHONDONTWRITEBYTECODE=1
export DYNAMODB_REGION="ap-southeast-1"
export EXCHANGE_TESTING=1
export TWS_JSON_LOG_INDENT=0
export CLOUDSDK_PYTHON="C:\Users\ArbynAcosta\AppData\Local\Programs\Python\Python37\python.exe"

# -------------------------------------------------------------------------+
# Custom personal aliases                                                  |
# -------------------------------------------------------------------------+

alias ipython="python -c \"from IPython import embed; embed()\""
