function fish_greeting
	fortune -a computers
end

# Source Functions from functions/
source ~/.config/fish/functions/extract.fish

# Aliases
# Utilities
alias clock='watch -n .5 "lscpu | grep MHz"'
alias batt="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias zip="zip -r"
alias space="ncdu -x"

# Terminal Navigation
alias ls="exa --icons -g --color=always --group-directories-first"
alias la="exa --icons -ga --color=always --group-directories-first"
alias ll="exa --icons -gal --color=always --group-directories-first"
alias grep="grep --color=auto"
alias cp="cp -i"
alias df="df -h"
alias ..="cd .."
alias ...="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."

# Git
alias dotfiles='/usr/bin/git --git-dir=/home/bennett/.dotfiles --work-tree=/home/bennett'
alias gcommit="git commit -m"
alias gadd="git add"
alias gpush="git push"
alias gpull="git pull"
alias gstatus="git status"

# Set environment variables
set --export EDITOR vim
set --export GIT_EDITOR vim

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background
cat ~/.cache/wal/sequences &

# Set omf theme color
set -g theme_color_scheme terminal-dark-white
