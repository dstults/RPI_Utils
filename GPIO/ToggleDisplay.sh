#!/bin/bash
# Teaches you how to detect the state of GPIO pins and then
# shows you how to toggle their states (swap in/out) by command.

choice=0
lastError=""
echo "Loading..."
while [ true ]; do
#This both prevents random stdin and replaces 'sleep 1'.
	read -rs -d '' -t 1 -n 10000
	clear
	echo -en "\e[1mScreen state:\e[21m   "
	screenState=$(gpio -g read 27)
	if (( screenState == 1 )) ; then
		echo -e "\e[1;92mON\e[21;39m"
	elif (( screenState == 0 )) ; then
		echo -e "\e[1;31mOFF\e[21;39m"
	fi
	echo "1) Turn Display On"
	echo "2) Turn Display Off"
	echo "3) Exit"
	choice=""
#This clears any spammed input from the stdin.
	read -rs -d '' -t 0.2 -n 10000
	read -rs -p "Select an action [1, 2 or 3]? " -n1 choice
#This prevents 'enter' from breaking the if statements below.
	echo $choice
	tput cup 6 0
	choice=$((choice))
	if [ $choice == 1 ] && (( screenState == 0 )) ; then
		tput cup 5 2
		echo -e "\e[1;2;32mExecuting...\e[21;22;39m"
		gpio -g mode 27 in
	elif [ $choice == 1 ] && (( screenState == 1 )) ; then
		tput cup 5 2
		echo -e "\e[1;2;31mERROR: SCREEN ALREADY ON\e[21;22;39m"
	elif [ $choice == 2 ] && (( screenState == 1 )) ; then
		tput cup 5 2
		echo -e "\e[1;2;32mExecuting...\e[21;22;39m"
		gpio -g mode 27 out
	elif [ $choice == 2 ] && (( screenState == 0 )) ; then
		tput cup 5 2
		echo -e "\e[1;2;31mERROR: SCREEN ALREADY OFF\e[21;22;39m"
	elif [ $choice == 3 ] ; then
		tput cup 5 2
		echo -e "\e[1;2;32mExiting...\e[21;22;39m"
		exit 0
	else
		tput cup 5 2
		echo -e "\e[1;2;31mERROR: UNKNOWN INPUT\e[21;22;39m"
	fi
done
