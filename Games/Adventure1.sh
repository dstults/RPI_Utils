#!/bin/bash

gameOver=0

PCName="Corn"
PCLoc=1
PCHP=10
PCStr=3
PCDex=3
PCInt=3

AINameKnown=0
AIName="Rice"
AILoc=9
AIHP=10
AIStr=3
AIDex=3
AIInt=3

hasSomethingUseful[1]=0
hasSomethingUseful[2]=0
hasSomethingUseful[3]=0
hasSomethingUseful[4]=1
hasSomethingUseful[5]=2
hasSomethingUseful[6]=3
hasSomethingUseful[7]=0
hasSomethingUseful[8]=0
hasSomethingUseful[9]=0
resultText="You begin your quest."

function mainLoop {
	while (( choice != 9 && gameOver == 0 )) ; do
		clear
		GiveSitRep
		GetChoice
		CheckResult
	done
}

function GiveSitRep {
	echo "| | | | | | | | | |"
	tput cup 0 $((2*$PCLoc-1))
	echo -e "\e[1;32m*\e[0m"
	echo -e "HP: \e[32m$PCHP\e[0m / 10      \e[36mSTR: \e[32m$PCStr\e[36m    DEX: \e[32m$PCDex\e[36m    INT: \e[32m$PCInt\e[0m"
	echo
	echo -e $resultText
	echo
	read -d '' -rst 1 -n 10000
	if (( PCLoc == 1 )) ; then
		echo "You are standing in the shallow water of a beach."
	elif (( PCLoc == 2 )) ; then
		echo "You are standing in the sand on a beach."
	elif (( PCLoc == 3 )) ; then
		echo "You are standing at the entrance to a forest next to a beach."
	elif (( PCLoc == 4 )) ; then
		echo "You are in a sparse foresty area."
	elif (( PCLoc == 5 )) ; then
		echo "You are in a dense foresty area."
	elif (( PCLoc == 6 )) ; then
		echo "You are in a sparse foresty area."
	elif (( PCLoc == 7 )) ; then
		echo "You are standing at the entrance to a forest next to a beach."
	elif (( PCLoc == 8 )) ; then
		echo "You are standing in the sand on a beach."
	elif (( PCLoc == 9 )) ; then
		echo "You are standing in the shallow water of a beach."
	fi
	if (( PCLoc == AILoc )) ; then
		if (( AINameKnown == 1 )) ; then
			echo "You see $AIName."
		else
			echo "You see a stranger."
		fi
	fi
}

function GetChoice {
	EastWest
	echo -e "3) \e[1;32mSearch\e[0m"
	Interact
	echo -e "9) \e[31mKill self\e[0m"
	while true; do
		read -rsn1 choice
		case "$choice" in
			1|2|3|4|9 ) break;;
		esac
	done
}

function EastWest {
	if (( PCLoc < 9 )) ; then
		PCCanGoEast=1
		echo "1) Go East"
	else
		PCCanGoEast=0
		echo -e "1) \e[35mGo East\e[0m"
	fi
	if (( PCLoc > 1 )) ; then
		PCCanGoWest=1
		echo "2) Go West"
	else
		PCCanGoWest=0
		echo -e "2) \e[35mGo West\e[0m"
	fi
}

function Interact {
	if (( PCLoc == AILoc )) ; then
		if (( AINameKnown == 0 )) ; then
			echo -e "4) \e[1;33mTalk\e[0m"
		else
			echo -e "4) \e[1;31mFight\e[0m"
		fi
	else
		echo -e "4) \e[35m(no one around)\e[0m"
	fi

}

function CheckResult {
	if (( choice == 1 )) ; then
		if (( PCCanGoEast == 1 )) ; then
			resultText="You walk east."
			((PCLoc++))
		else
			resultText="You cannot swim that well!"
		fi
	elif (( choice == 2 )) ; then
		if (( PCCanGoWest == 1 )) ; then
			resultText="You walk west."
			((PCLoc--))
		else
			resultText="You cannot swim that well!"
		fi
	elif (( choice == 3 )) ; then
		if (( hasSomethingUseful[$PCLoc] == 1 )) ; then
			hasSomethingUseful[$PCLoc]=0
			resultText="You eat a strong banana! +2 STR"
			((PCStr+=2))
		elif (( hasSomethingUseful[$PCLoc] == 2 )) ; then
			hasSomethingUseful[$PCLoc]=0
			resultText="You drink a miracle sauce! +1 STR +1 DEX"
			((PCStr++))
			((PCDex++))
		elif (( hasSomethingUseful[$PCLoc] == 3 )) ; then
			hasSomethingUseful[$PCLoc]=0
			resultText="You eat a dazzling cherry! +1 STR +1 INT"
			((PCStr++))
			((PCInt++))
		else
			resultText="There is nothing of use here."
		fi
	elif ((choice == 4 )) ; then
		if (( PCLoc == AILoc )) ; then
			if (( AINameKnown == 1 )) ; then
				resultText="$PCName hits $AIName for $PCStr damage!"
				((AIHP-=$PCStr))
				resultText="$resultText\n$AIName hits $PCName for $AIStr damage!"
				((PCHP-=$AIStr))
				if (( PCHP <= 0 )) ; then
					gameOver=1
				elif (( AIHP <= 0 )) ; then
					gameOver=2
				fi
			else
				resultText="$PCName: \"\e[33mHello stranger, my name is $PCName, what's your name?\e[0m\""
				resultText="$resultText\n$AIName: \"\e[33mMy name is $AIName and I am going to KILL YOU!\e[0m\""
				AINameKnown=1
			fi
		else
			resultText="You're alone right now!"
		fi
	else
		resultText=""
	fi
}

function showIntro {
	clear
	echo -e "\e[1;33m====================================="
	echo "|                                   |"
	echo "| Welcome to the Island of Eternity |"
	echo "|                                   |"
	echo "====================================="
	echo "|                                   |"
	echo "| Your name is Corn.                |"
	echo "|                                   |"
	echo "| A storm blew you and your evil    |"
	echo "| twin onto the Island of Eternity. |"
	echo "|                                   |"
	echo "| Are you strong enough to win?     |"
	echo "| Prepare yourself!                 |"
	echo "|                                   |"
	echo -e "=====================================\e[0m"
	echo
	echo "Press any key to begin!"
	read -rsn1
}

function showOutro {
	if (( gameOver == 1 )) ; then
		clear
		echo -e "\e[1;33m====================================="
		echo "|                                   |"
		echo "|  Defeat in the Island of Eternity |"
		echo "|                                   |"
		echo "====================================="
		echo "|                                   |"
		echo "| Your name was Corn.               |"
		echo "|                                   |"
		echo "|                                   |"
		echo "| You were too weak and died.       |"
		echo "|                                   |"
		echo "|                                   |"
		echo "| Better luck next time!            |"
		echo "|                                   |"
		echo -e "=====================================\e[0m"
		echo
		echo "Press any key to end."
		read -rsn1
	elif (( gameOver == 2 )) ; then
		clear
		echo -e "\e[1;33m====================================="
		echo "|                                   |"
		echo "| Victory in the Island of Eternity |"
		echo "|                                   |"
		echo "====================================="
		echo "|                                   |"
		echo "| Your name is Corn.                |"
		echo "|                                   |"
		echo "| You have driven evil away.        |"
		echo "|                                   |"
		echo "| You will be remembered forever.   |"
		echo "|                                   |"
		echo "| Maybe you should try again!       |"
		echo "|                                   |"
		echo -e "=====================================\e[0m"
		echo
		echo "Press any key to end!"
		read -rsn1
	else
		clear
		echo -e "\e[1;33m====================================="
		echo "|                                   |"
		echo "| Suicide in the Island of Eternity |"
		echo "|                                   |"
		echo "====================================="
		echo "|                                   |"
		echo "| Your name was Corn.               |"
		echo "|                                   |"
		echo "| You had a life and you threw it   |"
		echo "| away.                             |"
		echo "|                                   |"
		echo "| What a party pooper.              |"
		echo "|                                   |"
		echo "|                                   |"
		echo -e "=====================================\e[0m"
		echo
		echo "Press any key to end!"
		read -rsn1
	fi
}

showIntro
mainLoop
showOutro
