#!/bin/bash

# Grab the log_file location from the previous script, or set it manually
if [ ! $1 = "" ]; then
    log_file=$1
else
    log_file=~/install_progress_log.txt
fi

# Download configs
echo "Downloading config files..." | tee -a $log_file
mkdir ~/downloaded_configs
git clone https://github.com/Bennett-Wendorf/dotfiles.git ~/downloaded_configs

echo "NOTE: At the moment, any setting up of git repos to track these dotfiles is not done automatically. The configs are merely copied to their proper location!" | tee -a $log_file

mkdir -p ~/.config

# TODO: Consider adding README to all configs that were downloaded that link back to my repo
if [-d ~/.config/autorandr ]; then
    echo "Autorandr configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/autorandr.old && mv ~/.config/autorandr/* ~/.config/autorandr.old/
    echo "Installing autorandr configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/autorandr/* ~/.config/autorandr;
else
    echo "Installing autorandr configs..." | tee -a $log_file
    mkdir ~/.config/autorandr && cp -r ~/downloaded_configs/.config/autorandr/* ~/.config/autorandr;
fi

if [-d ~/.config/awesome ]; then
    echo "Awesome configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/awesome.old && mv ~/.config/awesome/* ~/.config/awesome.old/
    echo "Installing awesome configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/awesome/* ~/.config/awesome;
else
    echo "Installing awesome configs..." | tee -a $log_file
    mkdir ~/.config/awesome && cp -r ~/downloaded_configs/.config/awesome/* ~/.config/awesome;
fi

if [-d ~/.config/bashtop ]; then
    echo "Bashtop configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/bashtop.old && mv ~/.config/bashtop/* ~/.config/bashtop.old/
    echo "Installing bashtop configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/bashtop/* ~/.config/bashtop;
else
    echo "Installing bashtop configs..." | tee -a $log_file
    mkdir ~/.config/bashtop && cp -r ~/downloaded_configs/.config/bashtop/* ~/.config/bashtop;
fi

if [-d ~/.config/code-oss ]; then
    echo "Code-oss configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/code-oss.old && mv ~/.config/code-oss/* ~/.config/code-oss.old/
    echo "Installing code-oss configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/code-oss/* ~/.config/code-oss;
    echo "Symlinking product.json for vscode..." | tee -a $log_file
    sudo ln -s ~/.config/code-oss/product.json /usr/lib/code/
else
    echo "Installing code-oss configs..." | tee -a $log_file
    mkdir ~/.config/code-oss && cp -r ~/downloaded_configs/.config/code-oss/* ~/.config/code-oss;
    echo "Symlinking product.json for vscode..." | tee -a $log_file
    sudo ln -s ~/.config/code-oss/product.json /usr/lib/code/
fi

if [-d ~/.config/dunst ]; then
    echo "Dunst configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/dunst.old && mv ~/.config/dunst/* ~/.config/dunst.old/
    echo "Installing dunst configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/dunst/* ~/.config/dunst;
else
    echo "Installing dunst configs..." | tee -a $log_file
    mkdir ~/.config/dunst && cp -r ~/downloaded_configs/.config/dunst/* ~/.config/dunst;
fi

if [-d ~/.config/eww ]; then
    echo "Eww configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/eww.old && mv ~/.config/eww/* ~/.config/eww.old/
    echo "Installing eww configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/eww/* ~/.config/eww;
else
    echo "Installing eww configs..." | tee -a $log_file
    mkdir ~/.config/eww && cp -r ~/downloaded_configs/.config/eww/* ~/.config/eww;
fi

if [-d ~/.config/fish ]; then
    echo "Fish configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/fish.old && mv ~/.config/fish/* ~/.config/fish.old/
    echo "Installing fish configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/fish/* ~/.config/fish;
else
    echo "Installing fish configs..." | tee -a $log_file
    mkdir ~/.config/fish && cp -r ~/downloaded_configs/.config/fish/* ~/.config/fish;
fi

if [-d ~/.config/flameshot ]; then
    echo "Flameshot configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/flameshot.old && mv ~/.config/flameshot/* ~/.config/flameshot.old/
    echo "Installing flameshot configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/flameshot/* ~/.config/flameshot;
else
    echo "Installing flameshot configs..." | tee -a $log_file
    mkdir ~/.config/flameshot && cp -r ~/downloaded_configs/.config/flameshot/* ~/.config/flameshot;
fi

if [-d ~/.config/gtk-3.0 ]; then
    echo "Gtk-3.0 configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/gtk-3.0.old && mv ~/.config/gtk-3.0/* ~/.config/gtk-3.0.old/
    echo "Installing gtk-3.0 configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/gtk-3.0/* ~/.config/gtk-3.0;
else
    echo "Installing gtk-3.0 configs..." | tee -a $log_file
    mkdir ~/.config/gtk-3.0 && cp -r ~/downloaded_configs/.config/gtk-3.0/* ~/.config/gtk-3.0;
fi

if [-f ~/.config/i3/config ]; then
    echo "I3 configs detected; backing up..." | tee -a $log_file
    mv ~/.config/i3/config ~/.config/i3/config.old
    echo "Installing i3 configs..." | tee -a $log_file
    cp ~/downloaded_configs/.config/i3/config ~/.config/i3/config;
else
    echo "Installing i3 configs..." | tee -a $log_file
    mkdir ~/.config/i3 && cp ~/downloaded_configs/.config/i3/config ~/.config/i3/config;
fi

if [-f ~/.config/i3lock/i3lock.sh ]; then
    echo "I3lock configs detected; backing up..." | tee -a $log_file
    mv ~/.config/i3lock/i3lock.sh ~/.config/i3lock/i3lock.sh.old
    echo "Installing i3lock configs..." | tee -a $log_file
    cp ~/downloaded_configs/.config/i3lock/i3lock.sh ~/.config/i3lock/i3lock.sh;
else
    echo "Installing i3lock configs..." | tee -a $log_file
    mkdir ~/.config/i3lock && cp ~/downloaded_configs/.config/i3lock/i3lock.sh ~/.config/i3lock/i3lock.sh;
fi

if [-d ~/.config/omf ]; then
    echo "Omf configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/omf.old && mv ~/.config/omf/* ~/.config/omf.old/
    echo "Installing omf configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/omf/* ~/.config/omf;
else
    echo "Installing omf configs..." | tee -a $log_file
    mkdir ~/.config/omf && cp -r ~/downloaded_configs/.config/omf/* ~/.config/omf;
fi

if [-f ~/.config/picom/picom.conf ]; then
    echo "Picom configs detected; backing up..." | tee -a $log_file
    mv ~/.config/picom/picom.conf ~/.config/picom/picom.conf.old
    echo "Installing picom configs..." | tee -a $log_file
    cp ~/downloaded_configs/.config/picom/picom.conf ~/.config/picom/picom.conf;
else
    echo "Installing picom configs..." | tee -a $log_file
    mkdir ~/.config/picom && cp ~/downloaded_configs/.config/picom/picom.conf ~/.config/picom/picom.conf;
fi

if [-d ~/.config/polybar ]; then
    echo "Polybar configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/polybar.old && mv ~/.config/polybar/* ~/.config/polybar.old/
    echo "Installing polybar configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/polybar/* ~/.config/polybar;
else
    echo "Installing polybar configs..." | tee -a $log_file
    mkdir ~/.config/polybar && cp -r ~/downloaded_configs/.config/polybar/* ~/.config/polybar;
fi

if [-d ~/.config/qt5ct ]; then
    echo "Qt5ct configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/qt5ct.old && mv ~/.config/qt5ct/* ~/.config/qt5ct.old/
    echo "Installing qt5ct configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/qt5ct/* ~/.config/qt5ct;
else
    echo "Installing qt5ct configs..." | tee -a $log_file
    mkdir ~/.config/qt5ct && cp -r ~/downloaded_configs/.config/qt5ct/* ~/.config/qt5ct;
fi

if [-d ~/.config/qtile ]; then
    echo "Qtile configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/qtile.old && mv ~/.config/qtile/* ~/.config/qtile.old/
    echo "Installing qtile configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/qtile/* ~/.config/qtile;
else
    echo "Installing qtile configs..." | tee -a $log_file
    mkdir ~/.config/qtile && cp -r ~/downloaded_configs/.config/qtile/* ~/.config/qtile;
fi

if [-d ~/.config/rofi ]; then
    echo "Rofi configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/rofi.old && mv ~/.config/rofi/* ~/.config/rofi.old/
    echo "Installing rofi configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/rofi/* ~/.config/rofi;
else
    echo "Installing rofi configs..." | tee -a $log_file
    mkdir ~/.config/rofi && cp -r ~/downloaded_configs/.config/rofi/* ~/.config/rofi;
fi

if [-d ~/.config/spicetify ]; then
    echo "Spicetify configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/spicetify.old && mv ~/.config/spicetify/* ~/.config/spicetify.old/
    echo "Installing spicetify configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/spicetify/* ~/.config/spicetify;
else
    echo "Installing spicetify configs..." | tee -a $log_file
    mkdir ~/.config/spicetify && cp -r ~/downloaded_configs/.config/spicetify/* ~/.config/spicetify;
fi

if [-d ~/.config/systemd/user ]; then
    echo "User level systemd configs detected; backing up..." | tee -a $log_file
    mkdir -p ~/.config/systemd/user.old && mv ~/.config/systemd/user/* ~/.config/systemd/user.old/
    echo "Installing user level systemd configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/systemd/user/* ~/.config/systemd/user;
    echo "Starting and enabling mpris proxy service..." | tee -a $log_file
    systemctl start --user mpris-proxy.service
    systemctl enable --user mpris-proxy.service
else
    echo "Installing user level systemd configs..." | tee -a $log_file
    mkdir -p ~/.config/systemd/user && cp -r ~/downloaded_configs/.config/systemd/user/* ~/.config/systemd/user;
    echo "Starting and enabling mpris proxy service..." | tee -a $log_file
    systemctl start --user mpris-proxy.service
    systemctl enable --user mpris-proxy.service
fi

if [-f ~/.config/terminator/config ]; then
    echo "Terminator configs detected; backing up..." | tee -a $log_file
    mv ~/.config/terminator/config ~/.config/terminator/config.old
    echo "Installing terminator configs..." | tee -a $log_file
    cp ~/downloaded_configs/.config/terminator/config ~/.config/terminator/config;
else
    echo "Installing terminator configs..." | tee -a $log_file
    mkdir ~/.config/terminator && cp ~/downloaded_configs/.config/terminator/config ~/.config/terminator/config;
fi

if [-d ~/.config/wal/colorschemes/dark ]; then
    echo "Wal configs detected; backing up..." | tee -a $log_file
    mkdir -p ~/.config/wal/colorschemes/dark.old && mv ~/.config/wal/colorschemes/dark/* ~/.config/wal/colorschemes/dark.old/
    echo "Installing wal configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/wal/colorschemes/dark/* ~/.config/wal/colorschemes/dark;
else
    echo "Installing wal configs..." | tee -a $log_file
    mkdir -p ~/.config/wal/colorschemes/dark && cp -r ~/downloaded_configs/.config/wal/colorschemes/dark/* ~/.config/wal/colorschemes/dark;
fi

if [-d ~/.config/zsh ]; then
    echo "Zsh configs detected; backing up..." | tee -a $log_file
    mkdir ~/.config/zsh.old && mv ~/.config/zsh/* ~/.config/zsh.old/
    echo "Installing zsh configs..." | tee -a $log_file
    cp -r ~/downloaded_configs/.config/zsh/* ~/.config/zsh;
    echo "Symlinking zshrc..." | tee -a $log_file
    sudo ln -s ~/.config/zsh/zshrc ~/.zshrc
else
    echo "Installing zsh configs..." | tee -a $log_file
    mkdir ~/.config/zsh && cp -r ~/downloaded_configs/.config/zsh/* ~/.config/zsh;
    echo "Symlinking zshrc..." | tee -a $log_file
    sudo ln -s ~/.config/zsh/zshrc ~/.zshrc
fi

if [-f ~/.config/kritarc ]; then
    echo "Krita configs detected; backing up..." | tee -a $log_file
    mv ~/.config/kritarc ~/.config/kritarc.old
    echo "Installing krita configs..." | tee -a $log_file
    cp ~/downloaded_configs/.config/kritarc ~/.config/kritarc;
else
    echo "Installing krita configs..." | tee -a $log_file
    cp ~/downloaded_configs/.config/kritarc ~/.config/kritarc;
fi

if [-f ~/.config/mimeapps.list ]; then
    echo "Mimeapps list detected; backing up..." | tee -a $log_file
    mv ~/.config/mimeapps.list ~/.config/mimeapps.list.old
    echo "Installing mimeapps list..." | tee -a $log_file
    cp ~/downloaded_configs/.config/mimeapps.list ~/.config/mimeapps.list;
else
    echo "Installing mimeapps list..." | tee -a $log_file
    cp ~/downloaded_configs/.config/mimeapps.list ~/.config/mimeapps.list;
fi

if [-d ~/PacmanHooks ]; then
    echo "Pacman hooks directory detected; backing up..." | tee -a $log_file
    mkdir ~/PacmanHooks.old && mv ~/PacmanHooks/* ~/PacmanHooks.old/
    echo "Installing pacman hooks..." | tee -a $log_file
    cp -r ~/downloaded_configs/PacmanHooks/* ~/PacmanHooks;
    # TODO: consider iterating over hooks in directory instead of hardcoding?
    echo "Symlinking pacman hooks..." | tee -a $log_file
    sudo mkdir -p /etc/pacman.d/hooks
    sudo ln -s ~/PacmanHooks/pkgclean.hook /etc/pacman.d/hooks/pkgclean.hook
    sudo ln -s ~/PacmanHooks/pkgpurge.hook /etc/pacman.d/hooks/pkgpurge.hook
else
    echo "Installing pacman hooks..." | tee -a $log_file
    mkdir ~/PacmanHooks && cp -r ~/downloaded_configs/PacmanHooks/* ~/PacmanHooks;
fi

if [-d ~/scripts ]; then
    echo "Scripts directory detected; backing up..." | tee -a $log_file
    mkdir ~/scripts.old && mv ~/scripts/* ~/scripts.old/
    echo "Installing scripts..." | tee -a $log_file
    cp -r ~/downloaded_configs/scripts/* ~/scripts;
    if [ "${touchscreen_choice^^}" = "Y" ]; then
        echo "Setting up touchscreen-fix service..." | tee -a $log_file
        sudo mkdir -p /opt/touchscreen_fix
        sudo ln ~/scripts/touchscreen_fix/resume.sh /opt/touchscreen_fix/
        sudo ln touchscreen-fix.service /etc/systemcd/system/
        sudo systemctl daemon-reload
        sudo systemctl start touchscreen-fix.service
        sudo systemctl enable touchscreen-fix.service
    else
        echo "OK! Not installing touchscreen-fix service" | tee -a $log_file
    fi
else
    echo "Installing scripts..." | tee -a $log_file
    mkdir ~/scripts && cp -r ~/downloaded_configs/scripts/* ~/scripts;
    echo "Do you have a touchscreen on this device? [Y]es or [N]o."
    read touchscreen_choice
    if [ "${touchscreen_choice^^}" = "Y" ]; then
        echo "Setting up touchscreen-fix service..." | tee -a $log_file
        sudo mkdir -p /opt/touchscreen_fix
        sudo ln ~/scripts/touchscreen_fix/resume.sh /opt/touchscreen_fix/
        sudo ln touchscreen-fix.service /etc/systemcd/system/
        sudo systemctl daemon-reload
        sudo systemctl start touchscreen-fix.service
        sudo systemctl enable touchscreen-fix.service
    else
        echo "OK! Not installing touchscreen-fix service" | tee -a $log_file
    fi
fi

if [-f ~/.bashrc ]; then
    echo "Bashrc detected; backing up..." | tee -a $log_file
    mv ~/.bashrc ~/.bashrc.old
    echo "Installing bashrc..." | tee -a $log_file
    cp ~/downloaded_configs/.bashrc ~/.bashrc;
else
    echo "Installing bashrc..." | tee -a $log_file
    cp ~/downloaded_configs/.bashrc ~/.bashrc;
fi

if [-f ~/.fehbg ]; then
    echo "Fehbg detected; backing up..." | tee -a $log_file
    mv ~/.fehbg ~/.fehbg.old
    echo "Installing fehbg..." | tee -a $log_file
    cp ~/downloaded_configs/.fehbg ~/.fehbg;
else
    echo "Installing fehbg..." | tee -a $log_file
    cp ~/downloaded_configs/.fehbg ~/.fehbg;
fi

if [-f ~/.tmux.conf ]; then
    echo "Tmux configs detected; backing up..." | tee -a $log_file
    mv ~/.tmux.conf ~/.tmux.conf.old
    echo "Installing tmux configs..." | tee -a $log_file
    cp ~/downloaded_configs/.tmux.conf ~/.tmux.conf;
else
    echo "Installing tmux configs..." | tee -a $log_file
    cp ~/downloaded_configs/.tmux.conf ~/.tmux.conf;
fi

if [-f ~/.xprofile ]; then
    echo "Xprofile detected; backing up..." | tee -a $log_file
    mv ~/.xprofile ~/.xprofile.old
    echo "Installing xprofile..." | tee -a $log_file
    cp ~/downloaded_configs/.xprofile ~/.xprofile;
else
    echo "Installing xprofile..." | tee -a $log_file
    cp ~/downloaded_configs/.xprofile ~/.xprofile;
fi

echo "Do you want to remove the downloaded configs now (keeping the newly copied ones)? [Y]es or [N]o."
read remove_choice
if [ "${remove_choice^^}" = "Y" ];l then
    echo "Removing downloaded config directory..." | tee -a $log_file
    rm -rf ~/downloaded_configs
else
    echo "Not removing downloaded_configs directory. You will need to do that manually!" | tee -a $log_file
fi