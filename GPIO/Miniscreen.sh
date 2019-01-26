#!./bin/bash
# This script tells you how to modify the bootup config so that stdout
# will go to the GPIO-attached screen instead of the HDMI plug.

echo "I am about to launch:"
echo "sudo nano /usr/share/X11/xorg.conf.d/99-fbturbo.conf"
echo
echo "Find the line that says /dev/fb0"
echo "and change it to read   /dev/fb1"
echo
echo "Press any key to edit and save."

sudo nano /usr/share/X11/xorg.conf.d/99-fbturbo.conf
