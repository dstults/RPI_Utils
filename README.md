# RPI_Utils
This is a collection of some of my non-special-purpose Raspberry Pi bash scripts and similar items.

General

TotalUpdate.sh - Refreshes repositories, updates everything, cleans up, updates firmware, then prompts to reboot.

Network

There are some network utilities and update override utilities that I made because when I was living in China, the country's firewall blocked certain IP addresses so very often OS installations and upgrades would fail.

One problem was that Google is blocked in China, thus when I tried to update the pi's default operating system, it would fail because Chromium couldn't update. One of the scripts detects whether the system is set to whether the update for Chromium is blocked, report back to you, and then it will prompt you asking you whether you want to block it (thereby making it possible to update your system without error).

There is also a script to check to see if an IP address of your choice is blocked or not and then it will try to diagnose the nature of the blockage and tell you how to fix it.

GPIO

For a while I used a shell that had four buttons and a small text display attached to it. There was no documentation on how to interface with the shell so I had to find out for myself. The script would first dump the state of all the pins to a text map. It would then refresh every second, reporting any changes to the pin states. I was able to use this to determine which GPIO pins were affected by the buttons.

Eventually I found out how to interface with the screen, so I made a script that mapped one button to toggling the backlight on and off, and another two that when pressed in unison would prompt on the screen whether you wanted to shut down the pi or not. Clicking on one would be yes, the other would return no. As the screen and shell are now gone, I have now reconfigured the script to just pretend to do those things.

Webserver

I made a PHP page that asks for a password, and once entered lets you shut down the pi via webpage. Useful when you don't want to install a massive package just to do this one tiny function.

...and many more!

Having to self-learn bash to prepare the aforementioned scripts, I prepared a large amount of scripts that test colors, switch/case statements and more. Feel free to browse around. Maybe one day I'll make my own bash tutorial.
