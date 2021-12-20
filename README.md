# RPI_Utils

Some Raspberry Pi or general use Bash scripts

# General

- TotalUpdate.sh - Refreshes repositories, upgrades, prompts to upgrade OS, cleans up, prompts to reboot.

# Network

- CheckVPN.sh - Helps you scan if a target IP address (i.e. your VPN server) is detectable and if so, whether the chosen port is open. If any step fails in this process, the script will tell you what you probably need to do to fix the situation.
- ChromiumUpdate.sh - Google is blocked in China, if you don't block Chromium from updating, your system updates will fail and things will break. This helps you to prevent that from happening.

# Games

- Adventure1.sh - I was on a long plane ride and I got bored. This is a simple RPG that you practically can't lose.
- Adventure2.sh - When I got home I cleaned up the script a little and made it smarter, still basically the same game.

# GPIO

- BGControl.sh - Background script to run on a headless system with buttons and a miniscreen attached. Allows for a simplistic input console backlight to be toggled on and off and for the machine to be shutdown without having to connect via other means.
- GPIOReadAll.sh - Quickly display the states of the GPIO pins so as to debug and test which pins are which.
- Miniscreen.sh	- This script tells you how to modify the bootup config so that stdout will go to the GPIO-attached screen instead of the HDMI plug.
- ToggleDisplay.sh - Teaches you how to detect the state of GPIO pins and then shows you how to toggle their states (swap in/out) by command.
- ToggleDisplay_Whiptail.sh - Simplistic whiptail script to control case screen backlight.
