alias dotfiles='/usr/bin/git --git-dir=/home/bennett/dotfiles --work-tree=/home/bennett'
alias clock='watch -n .5 "lscpu | grep MHz"'

function fish_greeting
	fortune -a computers
end
