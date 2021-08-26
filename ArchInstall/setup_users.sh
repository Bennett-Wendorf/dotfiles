#!/bin/bash

log_file=~/install_progress_log.txt

echo "Starting networkmanager to handle internet..." | tee -a $log_file
systemctl start NetworkManager

echo "Do you want to setup wifi now? [Y]es or [N]o."
read wifi_choice
if [ "${wifi_choice^^}" = "Y" ]; then
    echo "Setting up wifi..." | tee -a $log_file
    nmtui
else
    echo "OK! Not setting up wifi." | tee -a $log_file
fi

echo "Enabling networkmanager on boot..." | tee -a $log_file
systemctl enable NetworkManager

echo "Now we need to set up a regular user account to use instead of the root account" | tee -a $log_file
read -r -p "What would you like to set your username as? " username_input
echo "Setting up account for new user '${username_input}'..." | tee -a $log_file
useradd -m -G wheel $username_input
echo "Setting a password for the new user '${username_input}'..." | tee -a $log_file
passwd $username_input

echo "Enabling command execution for all members of wheel (including our new user)..." | tee -a $log_file
sed -i "s/^# %wheel ALL=(ALL) ALL.*/%wheel ALL=(ALL) ALL/" /etc/sudoers

./install_basic_apps.sh $log_file