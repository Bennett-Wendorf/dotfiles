#!/bin/bash

# Grab the video driver from the previous script to allow us to uninstall extra video drivers in here
if [ ! $1 = "" ]; then
    vid_driver=$1
else
    vid_driver="xf86-video-intel"
fi

# Grab the log_file location from the previous script, or set it manually
if [ ! $2 = "" ]; then
    log_file=$2
else
    log_file=~/install_progress_log.txt
fi

# Grab the package manager from the previous script, or figure out what to use
if [ ! $3 = "" ]; then
    package_manager=$3
else
    if type -p paru; then
        # Paru is installed, so use that
        package_manager="paru"
    elif type -p trizen; then
        package_manager="trizen"
    elif type -p yay; then
        package_manager="yay"
    else
        echo "No known AUR helper installed. Some things here WILL break!!!" | tee -a $log_file
        package_manager="sudo pacman"
    fi
fi

# Grab lists of all installed AUR and regular packages and install them
echo "Creating directories for package lists" | tee -a $log_file
mkdir /tmp/pkg_lists
mkdir /tmp/pkg_lists/pacman
mkdir /tmp/pkg_lists/aur
git clone https://gist.github.com/Bennett-Wendorf/22361d7ab13b8be492934ea48eba64ed.git /tmp/pkg_lists/pacman
git clone https://gist.github.com/Bennett-Wendorf/99903062c63920216cc533ed3fb1850d.git /tmp/pkg_lists/aur

echo "Installing packages from pacman" | tee -a $log_file
sudo pacman -S --noconfirm --needed - < /tmp/pkg_lists/pacman/pacman-list.pkg || echo "Pacman package install failed!" | tee -a $log_file

# Install packages from the AUR, but only if a known AUR helper is installed
if [ ! $package_manager = "sudo pacman" ]; then
    echo "Installing packages from AUR" | tee -a $log_file
    $package_manager -S --noconfirm --needed - < /tmp/pkg_lists/aur/aur-list.pkg || echo "AUR package install failed!" | tee -a $log_file
fi

# Uninstall extra video drivers
video_driver_list=(xf86-video-intel xf86-video-amdgpu nvidia nvidia-settings nvidia-utils)
if [ $vid_driver = "xf86-video-amdgpu" ]; then
    unset video_driver_list[1]
elif [ $vid_driver = "nvidia nvidia-settings nvidia-utils" ]; then
    unset video_driver_list[2]
    unset video_driver_list[3]
    unset video_driver_list[4]
else
    unset video_driver_list[0]
fi
echo "Removing packages ${video_driver_list[*]}..." | tee -a $log_file
$package_manager -Rns --noconfirm ${video_driver_list[*]}

./install_configs.sh $log_file
