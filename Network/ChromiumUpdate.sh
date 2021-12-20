#!/bin/bash
appName="Chromium"
appPackage="rpi-chromium-mods"
echo -e "\e[0mLooking for $appName..."
dpkg -l $appPackage > /dev/null
if [ $? == 0 ] ; then
	echo -e "\e[32m$appName is installed.\e[0m"
else
	echo -e "\e[31m$appName ($appPackage) is NOT installed.\e[0m"
	exit 1
fi
echo "Checking whether it can update..."
holdList=$(sudo apt-mark showhold)
if [[ $holdList == *$appPackage* ]] ; then
	canUpdate=0
	echo -e "\e[31m$appName CANNOT update.\e[0m"
else
	canUpdate=1
	echo -e "\e[32m$appName CAN update.\e[0m"
fi
echo "Should $appName be able to update?"
select ync in "Yes" "No" "Cancel"; do
	case $ync in
		Yes )
			if [ $canUpdate = 0 ] ; then
				sudo apt-mark unhold $appPackage > /dev/null
				echo -e "\e[32m$appName updates no longer held back.\e[0m"
			else
				echo -e "\e[33mNo changes made.\e[0m"
			fi ;
			break ;;
		No )
			if [ $canUpdate = 1 ] ; then
				sudo apt-mark hold $appPackage > /dev/null
				echo -e "\e[31m$appName updates put on hold.\e[0m"
			else
				echo -e "\e[33mNo changes made.\e[0m"
			fi ;
			break ;;
		Cancel )
			echo -e "\e[33mNo changes made.\e[0m";
			break;;
	esac
done
read -p "Press any key to end." -rsn1