#!/bin/bash

log_file=~/install_progress_log.txt

echo "Welcome to the full Arch install script." | tee -a $log_file
echo "This will install much of the base arch system, as well as continue on with my scripts for installing apps and configurations." | tee -a $log_file
echo "" | tee -a $log_file

echo "First we have the option to set up a swapfile. This is highly recommended!"
echo "Would you like to set up a swapfile now? [Y]es or [N]o."
read swapfile_choice
if [ "${swapfile_choice^^}" = "Y" ]; then
    echo "1) 1GB    2) 2GB  3) 3GB  4) 4GB"
    read -r -p "How large of a swapfile would you like? (default 1): " swap_size_choice
    case $swap_size_choice in 
        1)
            swap_size='1GB'
            ;;
        2)
            swap_size='2GB'
            ;;
        3)
            swap_size='3GB'
            ;;
        4)
            swap_size='4GB'
            ;;
        *)
            swap_size='1GB'
            ;;
    esac
    echo "Creating a swapfile of size: ${swap_size}" | tee -a $log_file
    fallocate -l $swap_size /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile none swap defaults 0 0" >> /etc/fstab
else
    echo "OK! Not setting up a swapfile" | tee -a $log_file
fi

echo "Next we need to set up the proper time and locale for you" | tee -a $log_file
echo ""
echo "For now this script just sets locale and timezone information to America/Chicago" | tee -a $log_file
echo "If this is not correct for you, skip this step and change these settings yourself later" | tee -a $log_file
echo "If you would like me to add support for different timezones in this script, open an issue at https://github.com/Bennett-Wendorf/dotfiles/issues" | tee -a $log_file

echo "Would you like to set up locale now? [Y]es or [N]o."
read locale_choice
if [ "${locale_choice^^}" = "Y" ]; then
    echo "Setting timezone..." | tee -a $log_file
    ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
    echo "Syncing hardware clock..." | tee -a $log_file
    hwclock --systohc
    # TODO Set up systemd-timesyncd here
    echo "Uncommenting the proper locale..." | tee -a $log_file
    locale='en-US.UTF-8 UTF-8'
    sed -i "s/^#${locale}.*/${locale}/" /etc/locale.gen
    echo "Generating locale..." | tee -a $log_file
    locale-gen
    # TODO Fix this usage of locale
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
else
    echo "OK! Not setting up locale information now. Please do this on your own later!" | tee -a $log_file
fi

read -r -p "What would you like to set your hostname as? " hostname_input
echo "Adding hostname '${hostname_input}' to '/etc/hostname'..." | tee -a $log_file
echo "${hostname_input}" >> /etc/hostname
echo "Setting up '/etc/hosts' file..." | tee -a $log_file
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     ${hostname_input}.localdomain     ${hostname_input}" >> /etc/hosts

echo "Changing the root user password..." | tee -a $log_file
passwd root

echo "Installing some needed networking and dev packages..." | tee -a $log_file
pacman --needed --noconfirm -Sy base-devel linux-headers networkmanager network-manager-applet dialog

echo "Would you like to install packages for wireless networking now? [Y]es or [N]o."
read wifi_choice
if [ "${wifi_choice^^}" = "Y" ]; then
    echo "Installing wireless networking tools now..." | tee -a $log_file
    pacman --needed --noconfirm -S wireless_tools wpa_supplicant
else
    echo "OK! Not installing wireless networking tools." | tee -a $log_file
fi

echo "Would you like to install packages for MSDOS file systems now? [Y]es or [N]o."
read dos_file_choice
if [ "${dos_file_choice^^}" = "Y" ]; then
    echo "Installing MSDOS filesystem tools now..." | tee -a $log_file
    pacman --needed --noconfirm -S mtools dosfstools
else
    echo "OK! Not installing MSDOS filesystem tools." | tee -a $log_file
fi

echo "Does your system boot in UEFI mode? [Y]es or [N]o."
read uefi_choice
if [ "${uefi_choice^^}" = "Y" ]; then
    echo "Installing efi boot manager now..." | tee -a $log_file
    pacman --needed --noconfirm -S efibootmgr
else
    echo "OK! Not installing efi boot manager." | tee -a $log_file
fi

echo "Are you dual booting your system with multiple operating systems? [Y]es or [N]o."
read dual_boot_choice
if [ "${dual_boot_choice^^}" = "Y" ]; then
    echo "Installing os prober now..." | tee -a $log_file
    pacman --needed --noconfirm -S os-prober
else
    echo "OK! Not installing os prober." | tee -a $log_file
fi

echo "Installing grub..." | tee -a $log_file
pacman --needed --noconfirm -S grub

if [ "${uefi_choice^^}" = "Y" ]; then
    echo "Setting up grub with UEFI boot..." | tee -a $log_file
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
else
    echo "Setting up grub with legacy bios boot..." | tee -a $log_file
    # TODO Add proper disk here
    grub-install --target=i386-pc /dev/vda
fi

echo "Initializing grub config..." | tee -a $log_file
grub-mkconfig -o /boot/grub/grub.cfg
echo "I'll puase here so you can look over this config a bit. If you are dual booting, make sure that the windows (or other os) bootloader shows up in this config."
echo "Does it look right? [Y]es or [N]o"
read grub_correct
if [ "${grub_correct^^}" = "Y" ]; then
    echo "Looks like grub is set up properly. Moving on" | tee -a $log_file
else
    echo "GRUB CONFIG HAS ERRORS! TERMINATING NOW!" | tee -a $log_file
    exit 1
fi

# Enable parallel downloads and some other pacman settings
echo "Setting up some pacman settings such as parallel downloads before we continue..." | tee -a $log_file
parallel_download_amount=5
sudo sed -i "s/^#ParallelDownloads =.*/ParallelDownloads = ${parallel_download_amount}/" /etc/pacman.conf
sudo sed -i "s/^#Color.*/Color/" /etc/pacman.conf
sudo sed -i "s/^#VerbosePkgLists =.*/VerbosePkgLists/" /etc/pacman.conf
echo ""

echo "At this point you will need to do a few more things manually, as they cannot be done in this script." | tee -a $log_file
echo "Make sure you read through all of these instructions before continuing. Some of them may clear your screen!" | tee -a $log_file
echo "1) Run the 'exit' command to leave the chroot environment" | tee -a $log_file
echo "2) Run 'umount -a' to unmount all disks. It should be OK if they are showing as busy." | tee -a $log_file
echo "3) Reboot the computer and remove the installation media while it is off." | tee -a $log_file
echo "4) Ensure that grub shows up correctly and log in with the root user again." | tee -a $log_file
echo "5) Upon login, run the setup_users.sh script to continue the remainder of the setup!" | tee -a $log_file
echo "Thanks for using this portion of my install script!"

