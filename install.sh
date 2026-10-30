#!/bin/bash

clear

# Check if apt is installed. Stop the script if it is not.
if ! command -v apt > /dev/null 2>&1; then
    echo "apt is not installed. Quitting script"
    exit 1
fi


# Confirm with user
funny_remarks=("Make this anymore legal." "Sue you." "Do your taxes." "Help you get laid.")
random_index=$(( RANDOM % ${#funny_remarks[@]} ))

echo "Plezy Raspberry Pi install script: joshrandall8478

This script assumes the following:
1. You are installing this on a Raspberry Pi, or arm64 debian equivalent.
2. This Pi is not already configured. Meaning this is Raspberry Pi OS **LITE**.
3. You already have a server you wish to connect to.

This will do the following:
1. Install the Debian Arm64 build of Plezy from the Plezy website, and its dependencies.
    a. This will install wget to grab the .deb package.
2. Install LXDE, openbox, lightdm, 
3. Install the LXDE autostart and openbox configs from this repo.
    a. This leaves Control + Alt + T as a way to open the terminal, if you need to configure stuff on device.
4. Configure the display manager to autostart and login as the current user.

What this won't do...
1. ${funny_remarks[$random_index]}

Proceed? [y/N]"

read -r proceed
if [ "$proceed" != "y" ] && [ "$proceed" != "Y" ]; then
    echo "Quitting script"
    exit 0
fi



# Install wget
echo "Installing wget"
sudo apt install -y wget

# Install plezy
echo "Installing plezy"
wget https://github.com/edde746/plezy/releases/latest/download/plezy-linux-arm64.deb
sudo apt install -y ./plezy-linux-arm64.deb

# Install the DE, WM, and DM
echo "Installing lightdm, lxde, and openbox"
sudo apt install -y lightdm lxde openbox

# Install the configs from this repo
echo "Installing configs"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HOME/.config/openbox" "$HOME/.config/lxsession/LXDE"
cp "$script_dir/lxde-rc.xml" "$HOME/.config/openbox/lxde-rc.xml"
cp "$script_dir/autostart" "$script_dir/desktop.conf" "$HOME/.config/lxsession/LXDE/"

# Keep the original lightdm config the first time this runs
if [ -f /etc/lightdm/lightdm.conf ] && [ ! -f /etc/lightdm/lightdm.conf.bak ]; then
    sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
fi
sed "s/CURRENT_USER/$(id -un)/" "$script_dir/lightdm.conf" | sudo tee /etc/lightdm/lightdm.conf > /dev/null

# Boot into the display manager, since Raspberry Pi OS Lite boots to the console
echo "Enabling lightdm"
sudo systemctl enable lightdm
sudo systemctl set-default graphical.target

echo "Done. Reboot to start Plezy."
