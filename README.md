# RPI_Utils

This is a collection of some of my non-special-purpose Raspberry Pi bash scripts and similar items.

# General

- TotalUpdate.sh - Refreshes repositories, updates everything, cleans up, updates firmware, then prompts to reboot.

# Games

- Adventure1.sh - I was on a long plane ride and I got bored. This is a simple RPG that you practically can't lose.
- Adventure2.sh - When I got home I cleaned up the script a little and made it smarter, still basically the same game.

# Network

- CheckVPN.sh - Helps you scan if a target IP address (i.e. your VPN server) is detectable and if so, whether the chosen port is open. If any step fails in this process, the script will tell you what you probably need to do to fix the situation.
- ChromiumUpdate.sh - Google is blocked in China, if you don't block Chromium from updating, your system updates will fail and things will break. This helps you to prevent that from happening.

# GPIO

- BGControl.sh - Background script to run on a headless system with buttons and a miniscreen attached. Allows for a simplistic input console backlight to be toggled on and off and for the machine to be shutdown without having to connect via other means.
- GPIOReadAll.sh - Quickly display the states of the GPIO pins so as to debug and test which pins are which.
- Miniscreen.sh	- This script tells you how to modify the bootup config so that stdout will go to the GPIO-attached screen instead of the HDMI plug.
- ToggleDisplay.sh - Teaches you how to detect the state of GPIO pins and then shows you how to toggle their states (swap in/out) by command.
- ToggleDisplay_Whiptail.sh - Simplistic whiptail script to control case screen backlight.

# Webserver

- I made a PHP page that asks for a password, and once entered lets you shut down the pi via webpage. Useful when you don't want to install a massive package just to do this one tiny function.

# ...and many more!

Having to self-learn bash to prepare the aforementioned scripts, I prepared a large amount of scripts that test colors, switch/case statements and more. Feel free to browse around. Maybe one day I'll make my own bash tutorial.
