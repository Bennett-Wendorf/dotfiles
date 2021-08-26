#!/bin/bash

terminal_emulator="terminator"
package_manager="sudo pacman"

# Grab the log_file location from the previous script, or set it manually
if [ ! $1 = "" ]; then
    log_file=$1
else
    log_file=~/install_progress_log.txt
fi

echo "Welcome to my installation script of Bennett-Wendorf/dotfiles!" | tee -a $log_file
echo ""

echo "To access AUR packages, you will need to install an AUR helper such as 'Paru'. Note that if you choose to skip this, some things WILL break" | tee -a $log_file
echo "1) paru 	2) trizen 3) yay 4) Skip"
read -r -p "Choose your AUR helper (will not re-install) (default 1): " aur_choice
case $aur_choice in 
    1)
        aur_helper='paru'
        ;;
    2)
        aur_helper='trizen'
        ;;
    3)
        aur_helper=""
        ;;
    *)
        aur_helper='paru'
        ;;
esac
if [ ! $aur_helper =  "" ]; then
    echo "Installing ${aur_helper}..." | tee -a $log_file
    git clone https://aur.archlinux.org/${aur_helper}.git
    cd $aur_helper
    makepkg -si --needed --noconfirm
    package_manager="${aur_helper}"
else
    echo "Not installing an AUR helper. This script WILL break!" | tee -a $log_file
fi
echo ""

# TODO: Move this into the full system install as it needs a reboot to take effect
# Enable parallel downloads and some other pacman settings
echo "Setting up some pacman settings such as parallel downloads before we begin..." | tee -a $log_file
parallel_download_amount=5
sudo sed -i "s/^#ParallelDownloads =.*/ParallelDownloads = ${parallel_download_amount}/" /etc/pacman.conf
sudo sed -i "s/^#Color.*/Color/" /etc/pacman.conf
sudo sed -i "s/^#VerbosePkgLists =.*/VerbosePkgLists/" /etc/pacman.conf
echo ""

echo "" | sudo tee -a /etc/pacman.conf
echo "[multilib]" | sudo tee -a /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf

echo "Syncing repos and running full system update..." | tee -a $log_file
$package_manager -Syu --noconfirm
clear

# choose video driver
echo "1) xf86-video-intel 	2) xf86-video-amdgpu 3) nvidia 4) Skip"
read -r -p "Choose your video card driver (will not re-install) (default 1): " vid_driver_choice
case $vid_driver_choice in 
    1)
        vid_driver='xf86-video-intel'
        ;;
    2)
        vid_driver='xf86-video-amdgpu'
        ;;
    3)
        vid_driver='nvidia nvidia-settings nvidia-utils'
        ;;
    4)
        vid_driver=""
        ;;
    *)
        vid_driver='xf86-video-intel'
        ;;
esac
$package_manager -S $vid_driver --noconfirm --needed
echo ""

echo "Installing preferred terminal emulator..." | tee -a $log_file
$package_manager -S $terminal_emulator --noconfirm --needed
if type -p $terminal_emulator > /dev/null; then
    echo "${terminal_emulator} Installed" | tee -a $log_file
else
    echo "${terminal_emulator} FAILED TO INSTALL!!!" | tee -a $log_file
fi
echo ""

echo "Installing xorg..." | tee -a $log_file
$package_manager -S xorg --noconfirm --needed
# Checking for xrandr here since it is included in xorg
if type -p xrandr > /dev/null; then
    echo "xorg Installed" | tee -a $log_file
else
    echo "xorg FAILED TO INSTALL!!!" | tee -a $log_file
fi
echo ""

# WINDOW MANAGERS/DESKTOP ENVIRONMENTS
echo "Installing qtile..." | tee -a $log_file
$package_manager -S qtile --noconfirm
if type -p qtile > /dev/null; then
    echo "qtile Installed" | tee -a $log_file
else
    echo "qtile FAILED TO INSTALL!!!" | tee -a $log_file
fi
echo ""

echo "Installing awesome..." | tee -a $log_file
$package_manager -S awesome --noconfirm
if type -p awesome > /dev/null; then
    echo "awesome Installed" | tee -a $log_file
else
    echo "asesome FAILED TO INSTALL!!!" | tee -a $log_file
fi
echo ""

echo "Installing lightdm..." | tee -a $log_file
$package_manager -S lightdm lightdm-gtk-greeter --noconfirm
if type -p lightdm > /dev/null; then
    echo "lightdm Installed" | tee -a $log_file
    greeter='lightdm-gtk-greeter'
    sudo sed -i "s/^#greeter-session=.*/greeter-session=${greeter}/" /etc/lightdm/lightdm.conf
    echo "Enabling lightdm on boot..." | tee -a $log_file
    sudo systemctl enable lightdm
else
    echo "lightdm FAILED TO INSTALL!!!" | tee -a $log_file
fi
echo ""

# FIREWALL
echo "Installing ufw (Uncomplicated Firewall)..." | tee -a $log_file
$package_manager -S ufw --noconfirm
if type -p ufw > /dev/null; then
    echo "ufw Installed" | tee -a $log_file
    sudo ufw enable
    sudo systemctl enable ufw
    sudo ufw default deny
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
    echo "ufw FAILED TO INSTALL!!!" | tee -a $log_file
fi
echo ""

# MISC PACKAGES
echo "Installing input drivers..." | tee -a $log_file
$package_manager -S libinput xf86-input-libinput xorg-xinput --noconfirm
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
if $package_manager -Q | grep xorg-xinput; then
    echo "xorg-xinput Installed" | tee -a $log_file
else
    echo "xorg-xinput FAILED TO INSTALL!!!" | tee -a $log_file
fi
echo ""

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
echo ""

echo "Would you like to set up touchpad settings for a laptop? [Y]es or [N]o"
read touchpad_setup
if [ "${touchpad_setup^^}" = "Y" ]; then
echo "Setting up 30-touchpad.conf file in '/etc/X11/xorg.conf.d'..." | tee -a $log_file
cat <<- EOF >/tmp/30-touchpad.conf
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
sudo mv /tmp/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
echo ""

./install_apps.sh $vid_driver $log_file $package_manager