#!/bin/bash
echo "==========================="
echo "Total Update Script"
echo "==========================="
read -p "Press [Enter] key to begin..."
logger "Commencing 'TotalUpdate.sh' to update system"
echo -n "[*] Refreshing repository cache..."
echo "==========================="
sudo apt update -y
echo "==========================="
echo "[*] Repository cache refresh complete."
echo "[*] Performing full upgrade..."
echo "      (will require your confirmation if you want to do a full OS upgrade)"
echo "==========================="
sudo apt full-upgrade
echo "==========================="
echo "[*] Full upgrade complete."
echo "[*] Removing unused or cached packages..."
echo "==========================="
sudo apt autoremove -y
sudo apt autoclean -y
echo "==========================="
echo "[*] Package cleanup complete."
logger "Completing 'TotalUpdate.sh' system update"
while true; do
	read -r -p "Do you wish to reboot? " choice
	case "$choice" in
		y|Y ) echo "[*] Rebooting..."; sudo reboot; break;;
		n|N ) echo "[*] Done."; break;;
		* ) echo "[-] Invalid response. Use 'y' or 'n'.";;
	esac
done
