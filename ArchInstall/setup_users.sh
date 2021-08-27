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
echo ""

echo "Now we need to set up a regular user account to use instead of the root account" | tee -a $log_file
read -r -p "What would you like to set your username as? " username_input
echo "Setting up account for new user '${username_input}'..." | tee -a $log_file
useradd -m -G wheel $username_input
echo "Setting a password for the new user '${username_input}'..." | tee -a $log_file
passwd $username_input

echo "Enabling command execution for all members of wheel (including our new user)..." | tee -a $log_file
sed -i "s/^# %wheel ALL=(ALL) ALL.*/%wheel ALL=(ALL) ALL/" /etc/sudoers

echo "At this point, we need to be logged in with a regular user, not the root user." | tee -a $log_file
echo "Read through these steps and then follow them to get started." | tee -a $log_file
echo "1) Run the 'exit' command to logout" | tee -a $log_file
echo "2) Login with the new user you just created: '${username_input}'" | tee -a $log_file
echo "3) At this point you can remove the old cloned repo with 'sudo rm -rf /root/dotfiles'" | tee -a $log_file
echo "4) Reclone this repo into ${username_input}'s home directory" | tee -a $log_file
echo "5) Run the 'install_basic_apps.sh' script from /home/${username_input}/dotfiles/ArchInstall to continue" | tee -a $log_file
echo "Make sure that you run the one in the user's home directory, not in root's home!" | tee -a $log_file