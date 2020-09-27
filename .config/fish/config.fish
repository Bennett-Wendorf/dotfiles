alias dotfiles='/usr/bin/git --git-dir=/home/bennett/.dotfiles --work-tree=/home/bennett'
alias clock='watch -n .5 "lscpu | grep MHz"'
alias batt="upower -i /org/freedesktop/UPower/devices/battery_BAT0"

function fish_greeting
	fortune -a computers
end

export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_DATA_DIRS=/usr/share/:/usr/local/share

# Install Ruby Gems to ~/ruby_gems
export GEM_HOME="$HOME/ruby_gems"
export PATH="$HOME/ruby_gems/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/lib/jvm/java-14-openjdk/bin:$PATH"

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background
cat ~/.cache/wal/sequences &

set -g theme_color_scheme terminal-dark-white
