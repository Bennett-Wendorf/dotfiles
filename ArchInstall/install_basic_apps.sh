#!/bin/bash

log_file=~/install_progress_log.txt
terminal_emulator="terminator"
package_manager="sudo pacman"

echo "Welcome to my installation script of Bennett-Wendorf/dotfiles!"

echo "To access AUR packages, you will need to install an AUR helper like 'Trizen'. Would you like to install Trizen now? [Y]es or [N]o."
read aur_choice
if [ "${aur_choice^^}" = "Y" ];l then
    echo "Installing AUR helper 'trizen'" | tee -a $log_file
    # Install trizen
    git clone https://aur.archlinux.org/trizen.git
    cd trizen
    makepkg -si

    # Set trizen as package manager
    package_manager="trizen"
else
    echo "Not installing trizen. No AUR packages will be able to be installed, so some installs may fail." | tee -a $log_file
fi

echo "Syncing repos and running full system update..." | tee -a $log_file
$package_manager -Syu --noconfirm

# choose video driver
echo "1) xf86-video-intel 	2) xf86-video-amdgpu 3) nvidia 4) Skip"
read -r -p "Choose your video card driver(default 1)(will not re-install): " vid_driver_choice
case $vid_driver_choice in 
[1])
	vid_driver='xf86-video-intel'
	;;
[2])
	vid_driver='xf86-video-amdgpu'
	;;
[3])
    vid_driver='nvidia nvidia-settings nvidia-utils'
    ;;
[4])
	vid_driver=""
	;;
[*])
	vid_driver='xf86-video-intel'
	;;
esac
$package_manager -S $vid_driver --noconfirm

echo "Installing preferred terminal emulator..." | tee -a $log_file
$package_manager -S $terminal_emulator --noconfirm
if type -p $terminal_emulator > /dev/null; then
    echo "${terminal_emulator} Installed" | tee -a $log_file
else
    echo "${terminal_emulator} FAILED TO INSTALL!!!" | tee -a $log_file
fi

echo "Installing xorg..." | tee -a $log_file
$package_manager -S xorg --noconfirm
# Checking for xrandr here since it is included in xorg
if type -p xrandr > /dev/null; then
    echo "xorg Installed" | tee -a $log_file
else
    echo "xorg FAILED TO INSTALL!!!" | tee -a $log_file
fi

# WINDOW MANAGERS/DESKTOP ENVIRONMENTS
echo "Installing qtile..." | tee -a $log_file
$package_manager -S qtile
if type -p qtile > /dev/null; then
    echo "qtile Installed" | tee -a $log_file
else
    echo "qtile FAILED TO INSTALL!!!" | tee -a $log_file
fi

echo "Installing awesome..." | tee -a $log_file
$package_manager -S awesome
if type -p awesome > /dev/null; then
    echo "awesome Installed" | tee -a $log_file
else
    echo "asesome FAILED TO INSTALL!!!" | tee -a $log_file
fi

echo "Installing lightdm..." | tee -a $log_file
$package_manager -S lightdm lightdm-gtk-greeter --noconfirm
if type -p lightdm > /dev/null; then
    echo "lightdm Installed" | tee -a $log_file
    greeter='lightdm-gtk-greeter'
    sudo sed -i "s/^#greeter-session=.*/greeter-session=${greeter}/" /etc/lightdm/lightdm.conf
    sudo systemctl start lightdm
    echo "Does lightdm look like it is working? [Y]es or [N]o."
    read lightdm_choice
    if [ "${lightdm_choice^^}" = "Y" ];l then
        echo "Great! Enabling it on boot." | tee -a $log_file
    else
        echo "Oh no! Not enabling it for now. Please fix the issue and then run 'sudo systemctl enable lightdm'" | tee -a $log_file
    fi
else
    echo "lightdm FAILED TO INSTALL!!!" | tee -a $log_file
fi

# FIREWALL
echo "Installing ufw (Uncomplicated Firewall)..." | tee -a $log_file
$package_manager -S ufw --noconfirm
if type -p ufw > /dev/null; then
    echo "ufw Installed" | tee -a $log_file
    sudo ufw enable
    echo "Now printing ufw status. Ensure this looks correct before continuing"
    sudo ufw status verbose
    echo ""
    echo "Does it look right? [Y]es or [N]o"
    read ufw_correct
    if [ "${ufw_correct^^}" = "Y" ]; then
        echo "All good! UFW status is correct! Enabling and adding default rules now" | tee -a $log_file
        sudo systemctl enable ufw
        sudo ufw defualt deny
        sudo ufw allow from 192.168.1.0/24
        sudo ufw allow from 192.168.0.0/24
        sudo ufw allow Deluge
        sudo ufw limit ssh
        echo "Checking ufw status again"
        sudo ufw status verbose
        echo ""
        echo "Does it look right? [Y]es or [N]o"
        read ufw_correct
        if [ "${ufw_correct^^}" = "Y" ]; then
            echo "Ufw is now enabled and default rules set" | tee -a $log_file
        else
            echo "NEED TO CHECK UFW STATUS FOR ERRORS!" | tee -a $log_file
        fi
    else
        echo "NEED TO CHECK UFW STATUS FOR ERRORS!" | tee -a $log_file
    fi
else
    echo "ufw FAILED TO INSTALL!!!" | tee -a $log_file
fi

# MISC PACKAGES
echo "Installing input drivers..." | tee -a $log_file
$package_manager -S libinput xf86-input-libinput xorg-input --noconfirm
if type -p libinput > /dev/null; then
    echo "libinput Installed" | tee -a $log_file
else
    echo "libinput FAILED TO INSTALL!!!" | tee -a $log_file
fi
if $package_manager -Q | grep xf86-input-libinput; then
    echo "xf86-input-libinput Installed" | tee -a $log_file
else
    echo "xf86-input-libinput FAILED TO INSTALL!!!" | tee -a $log_file
fi
if $package_manager -Q | grep xorg-input; then
    echo "xorg-input Installed" | tee -a $log_file
else
    echo "xorg-input FAILED TO INSTALL!!!" | tee -a $log_file
fi

echo "Would you like to install the lts kernel? [Y]es or [N]o"
read lts_kernel
if [ "${lts_kernel^^}" = "Y" ]; then
    echo "Installing lts kernel..." | tee -a $log_file
    $package_manager -S linux-lts linux-lts-headers --noconfirm
    if $package_manager -Q | grep linux-lts; then
        echo "lts kernel Installed" | tee -a $log_file
    else
        echo "Failed to install lts kernel" | tee -a $log_file
    fi
fi

echo "Would you like to set up touchpad settings for a laptop? [Y]es or [N]o"
read touchpad_setup
if [ "${touchpad_setup^^}" = "Y" ]; then
echo "Setting up 30-touchpad.conf file in '/etc/X11/xorg.conf.d'..." | tee -a $log_file
cat <<- EOF >/etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lmr"
    Option "NaturalScrolling" "true"
EndSection
EOF
fi

./install_apps.sh $vid_driver $log_file $package_manager