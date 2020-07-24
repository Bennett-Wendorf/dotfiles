#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
#[[ -z "$TMUX" ]] && exec tmux

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias dotfiles='/usr/bin/git --git-dir=/home/bennett/dotfiles --work-tree=/home/bennett'

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/ruby_gems"
export PATH="$PATH:$HOME/ruby_gems/bin"
