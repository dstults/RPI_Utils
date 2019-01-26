#!/bin/bash
# Quickly display the states of the GPIO pins so as to debug
# and test which pins are which.

clear

while [ $(gpio -1 read 7) != 0 ] ; do

	tput cup 0 0
	gpio readall

done

echo
