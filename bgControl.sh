#!/bin/bash
# This script is designed to run in the background, it will monitor input from three
# buttons linked to GPIO pins 7, 18, 29. They will let you shut down the system,
# exit out of the program, or control the backlight of a display with the power
# output to the backlight linked to GPIO pin 27.
# As this script is intended to run in the background, all stdout commands are commented.

shutdownSystem=0
buttonDown=0
while (( buttonDown == 1 || shutdownSystem == 0 )) ; do
	screenState=$(gpio -g read 27)

	if (( $(gpio -1 read 7) == 0 )) ; then
		if (( buttonDown == 0 && shutdownSystem == 0 )) ; then
			shutdownSystem=1
		fi
	fi
	if (( $(gpio -1 read 29) == 0 )) ; then
		if (( shutdownSystem == 1 )) ; then
			shutdownSystem=0
			gpio -g mode 27 out
		fi
		if (( buttonDown == 0 )) ; then
			if (( screenState == 1 )) ; then
				gpio -g mode 27 out
			else
				gpio -g mode 27 in
			fi
		fi
	fi
	if (( buttonDown == 0 && ( $(gpio -1 read 7) == 0 || $(gpio -1 read 18) == 0 || $(gpio -1 read 29) == 0 ) )) ; then
		buttonDown=1
	elif (( buttonDown == 1 && $(gpio -1 read 7) == 1 && $(gpio -1 read 18) == 1 && $(gpio -1 read 29) == 1 )) ; then
		buttonDown=0
		#echo "Button Up"
	fi

	if (( shutdownSystem == 1 )) ; then
		if (( screenState == 1 )) ; then
			gpio -g mode 27 out
		else
			gpio -g mode 27 in
		fi
	fi
	sleep 0.2
done

if (( shutdownSystem == 1 )) ; then
	gpio -g mode 27 in
	#echo "System shutdown."
	sudo shutdown now
else
	gpio -g mode 27 in
	#echo "Program ended."
fi
