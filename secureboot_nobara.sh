#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo ./secureboot_nobara.sh'"
    exit 1
fi

# Install required packages
echo "Installing required packages..."
dnf install -y mokutil openssl grub2-efi-x64-modules sbsigntools

# Generate a Machine Owner Key (MOK)
echo "Generating a new Machine Owner Key (MOK)..."
openssl req -new -x509 -newkey rsa:2048 -keyout /root/MOK.priv -outform DER -out /root/MOK.der -nodes -days 36500 -subj "/CN=Nobara Secure Boot/"

# Enroll the key into Secure Boot
echo "Enrolling the MOK into Secure Boot..."
mokutil --import /root/MOK.der

echo -e "\n============================================"
echo "A password will be set for MOK enrollment."
echo "You will need to confirm this during the next reboot."
echo -e "============================================\n"

read -p "Set a password for MOK enrollment: " mok_pass
(echo "$mok_pass"; echo "$mok_pass") | mokutil --password

# Sign the kernel and bootloader
echo "Signing the kernel and GRUB bootloader..."
sbsign --key /root/MOK.priv --cert /root/MOK.der --output /boot/vmlinuz-$(uname -r) /boot/vmlinuz-$(uname -r)
sbsign --key /root/MOK.priv --cert /root/MOK.der --output /boot/efi/EFI/fedora/grubx64.efi /boot/efi/EFI/fedora/grubx64.efi

# Update GRUB configuration
echo "Updating GRUB configuration..."
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-install

echo -e "\n============================================"
echo "Secure Boot setup complete!"
echo "Reboot your system and follow the MOK enrollment prompts."
echo "1. Select 'Enroll MOK' in the blue menu."
echo "2. Enter the password you set earlier."
echo "3. Confirm enrollment and boot into Nobara."
echo -e "============================================\n"

read -p "Press Enter to reboot now, or Ctrl+C to cancel." 
reboot
