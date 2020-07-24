alias dotfiles='/usr/bin/git --git-dir=/home/bennett/dotfiles --work-tree=/home/bennett'
alias clock='watch -n .5 "lscpu | grep MHz"'

function fish_greeting
	fortune -a computers
end
# Install Ruby Gems to ~/ruby_gems
export GEM_HOME="$HOME/ruby_gems"
export PATH="$HOME/ruby_gems/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background
cat ~/.cache/wal/sequences &


function pywal-pacwall
    wal -i "/home/bennett/Desktop/blue-black-cirguit.jpg" -b "#303030" -n
    pacwall -W
end
