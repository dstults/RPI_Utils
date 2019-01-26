#!/bin/bash

whiptail --menu "Display Toggle" 15 40 3 "On" "Off" "Exit"
if MENUCHOICE==0
	gpio -g mode 27 in
elseif MENUCHOICE==1
	gpio -g mode 27 out
fi
echo $MENUCHOICE
echo "Press any key to continue."
read
