#!/bin/bash
echo "==========================="
echo "Total Update Script"
echo "==========================="
read -p "Press [Enter] key to begin..."
logger "Commencing 'TotalUpdate.sh' to update system"
echo -n '[*] Refreshing repository cache...'
echo "==========================="
sudo apt-get update -y
echo "==========================="
echo '[*] Repository cache refresh complete.'
echo '[*] Performing full upgrade...'
echo "==========================="
sudo apt-get dist-upgrade -y
echo "==========================="
echo '[*] Full upgrade complete.'
echo '[*] Removing unused or cached packages...'
echo "==========================="
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "==========================="
echo '[*] Package cleanup complete.'
if [ $(which raspi-config | wc -l) -gt 0 ]; then
        echo '[*] Raspberry Pi Detected.'
        echo '[*] Update the Raspberry Pi firmware to the latest (if available)...'
		echo "==========================="
        sudo rpi-update
		echo "==========================="
        echo '[*] Done updating firmware.'
fi
logger "Completing 'TotalUpdate.sh' system update"
while true; do
        read -r -p "Do you wish to reboot? " choice
        case "$choice" in
                y|Y ) echo "[*] Rebooting..."; sudo reboot; break;;
                n|N ) echo "[*] Done."; break;;
                * ) echo "[-] Invalid response. Use 'y' or 'n'.";;
        esac
done