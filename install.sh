#!/bin/bash

clear
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
