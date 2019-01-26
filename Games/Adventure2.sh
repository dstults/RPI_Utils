#!/bin/bash

function getYN {
	echo $1
	while true; do
		read -rsn1 choice
		case "$choice" in
			1|y|Y ) choice=1; break;;
			0|n|N ) choice=0; break;;
		esac
	done
}

function get12 {
	echo $1
	while true; do
		read -rsn1 choice
		case "$choice" in
			1|2 ) break;;
		esac
	done
}

function preparePlayers {
	clear
	echo -e "\e[1mReturn to the Island of Eternity\e[0m"
	echo
	echo "  New Game Setup Menu"
	echo
	echo
	getYN "Use default configuration? (y,n)" ; useDefaults=$choice
	echo
	if (( useDefaults == 1 )) ; then
		pName[1]="Corn"
		pGender[1]=1
		pControl[1]=1
		pName[2]="Rice"
		pGender[2]=1
		pControl[2]=2
	elif (( useDefaults == 0 )) ; then
		read -p "P1 name: " pName[1]
		get12 "P1 gender: (1) male, (2) female" ; pGender[1]=$choice
		get12 "P1 control: (1) human, (2) computer" ; pControl[1]=$choice
		read -p "P2 name: " pName[2]
		get12 "P2 gender: (1) male, (2) female" ; pGender[2]=$choice
		get12 "P2 control: (1) human, (2) computer" ; pControl[2]=$choice
	fi
	for i in $(seq 1 2) ; do
		pHP_max[$i]=20
		pHP_cur[$i]=${pHP_max[1]}
		pFury[$i]=0
		pStr[$i]=4
		pDex[$i]=4
		pInt[$i]=4
		pResult[$i]="You begin your quest, ${pName[1]}!"
		rndTemp=$((1 + RANDOM % 4))
		case ${pGender[$i]} in
		1)	case $rndTemp in
			1) pSpell[$i]="Flame" ;;
			2) pSpell[$i]="Fireball" ;;
			3) pSpell[$i]="Spark" ;;
			4) pSpell[$i]="Thunderbolt" ;;
			esac ;;
		2)	case $rndTemp in
			1) pSpell[$i]="Icebolt" ;;
			2) pSpell[$i]="Frostshard" ;;
			3) pSpell[$i]="Vine Whip" ;;
			4) pSpell[$i]="Entangle" ;;
			esac ;;
		esac
	done
	pLoc[1]=1
	pLoc[2]=9
	clear
	echo -e "\e[1mReturn to the Island of Eternity\e[0m"
	echo
	for i in $(seq 1 2) ; do
		echo "     -Player $i:"
		echo -n "Name: ${pName[$i]}     "
		if (( pGender[$i] == 1 )) ; then
			echo "(male)"
		elif (( pGender[$i] == 2 )) ; then
			echo "(female)"
		fi
		echo "HP: ${pHP_cur[$i]} / ${pHP_max[$i]}     Fury: ${pFury[$i]}"
		echo "STR: ${pStr[$i]}   DEX: ${pDex[$i]}   INT: ${pInt[$i]}"
		echo "Magic: ${pSpell[$i]}"
		echo -n "Control: "
		if (( pControl[$i] == 1 )) ; then
			echo "Player"
		elif (( pControl[$i] == 2 )) ; then
			echo "Computer"
		fi
		echo "Player $i (${pName[$i]}) is ready."
		echo
		echo "Player $i created." > "player$i.log"
	done
	playersKnowEachOther=0
	gameOver=0
	echo "Player setup complete."
	echo
	read -p "Press [enter] to begin."
}

function prepareMap {
	mapTileType[1]=1
	mapTileType[2]=2
	mapTileType[3]=3
	mapTileType[4]=4
	mapTileType[5]=4
	mapTileType[6]=4
	mapTileType[7]=3
	mapTileType[8]=2
	mapTileType[9]=1
	for i in $(seq 1 9); do
		case ${mapTileType[$i]} in
		1)	tileName[$i]="Shallow Water"
			tileFG[$i]="36"
			tileBG[$i]="46" ;;
		2)	tileName[$i]="Beach"
			tileFG[$i]="33"
			tileBG[$i]="43" ;;
		3)	tileName[$i]="Grass"
			tileFG[$i]="33"
			tileBG[$i]="43" ;;
		4)	tileName[$i]="Forest"
			tileFG[$i]="32"
			tileBG[$i]="42" ;;
		esac
	done
	mapItem[1]=0
	mapItem[9]=0
	for i in $(seq 2 8); do
		echo -n "$((RANDOM % 4))"
		mapItem[$i]=$((RANDOM % 6))
	done
}

function mainLoop {
	while (( gameOver >= 0 )) ; do
		RotateTurns
		GiveSitRep
		GiveChoices
		GetChoice
		CheckResult
	done
}

function RotateTurns {
	if (( pTurn != 1 )) ; then
		pTurn=1
		pEnemy=2
	else
		pTurn=2
		pEnemy=1
	fi
	clear
	if (( pControl[$pTurn] == 1 && pControl[$pEnemy] == 1 )) ; then
		echo -e "\n\n  It's ${pName[$pTurn]}'s turn.\n\n"
		read -p "  Press [enter] key to begin." -rs
	fi
}

function GiveSitRep {
	
	# Export Results to Log File
	echo "${pResult[$pTurn]}" >> "player$pTurn.log"
	
	# Only display if it is a human-controlled player.
	# No input is needed, no variables are set.
	if (( pControl[$pTurn] == 1 )) ; then
		clear
		# Draw the Map
		sitRep="\n  Map: |"
		for i in $(seq 1 9); do
			if (( i == pLoc[$pTurn] )) ; then
					sitRep="$sitRep\e[1;${tileBG[$i]}m*\e[0;32m|"
			else
					sitRep="$sitRep\e[${tileBG[$i]}m \e[0;32m|"
			fi
		done
		sitRep="$sitRep\n  \e[1;${tileFG[${pLoc[$pTurn]}]}m${tileName[${pLoc[$pTurn]}]}]}\e[0m"
		sitRep="$sitRep\n  You See: "
		if (( pLoc[$pTurn] == pLoc[$pEnemy] )) ; then
			if (( playersKnowEachOther == 1 )) ; then
				sitRep="$sitRep\e[1;31m${pName[$pEnemy]}\e[0m"
			else
				if (( pGender[$((3-$pTurn))] == 1 )) ; then
					sitRep="$sitRep\e[1;33ma man\e[0m"
				elif (( pGender[$((3-$pTurn))] == 2 )) ; then
					sitRep="$sitRep\e[1;33ma woman\e[0m"
				fi
			fi
		else
			sitRep="$sitRep\e[35m(no one)\e[0m"
		fi
		# Player Info
		sitRep="$sitRep\n\n  \e[1m${pName[$pTurn]}\e[0;36m   HP: \e[32m${pHP_cur[$pTurn]}\e[36m / \e[32m${pHP_max[$pTurn]}\e[36m  Fury: \e[32m${pFury[$pTurn]}\e[36m"
		sitRep="$sitRep\n      STR: \e[32m${pStr[$pTurn]}\e[36m  DEX: \e[32m${pDex[$pTurn]}\e[36m  INT: \e[32m${pInt[$pTurn]}\e[0m"
		sitRep="$sitRep\n"
		# Last Turn's Results
		sitRep="$sitRep\n${pResult[$pTurn]}"
		if (( pControl[$pTurn] == 1 )) ; then
			echo -e "$sitRep"
			read -d '' -t 0.2 -rsn 10000
		fi
	fi
}

function GiveChoices {
	choiceMenu=""
	if (( gameOver > 0 )) ; then
		choiceMenu="1) \e[1mGame Over\e[0m"
	else
		if (( pLoc[$pTurn] < 9 )) ; then
			CanGoEast=1
			choiceMenu="$choiceMenu\n1) \e[1;33mGo East\e[0m"
		else
			CanGoEast=0
			choiceMenu="$choiceMenu\n1) \e[35mGo East\e[0m"
		fi
		if (( pLoc[$pTurn] > 1 )) ; then
			CanGoWest=1
			choiceMenu="$choiceMenu\n2) \e[1;33mGo West\e[0m"
		else
			CanGoWest=0
			choiceMenu="$choiceMenu\n2) \e[35mGo West\e[0m"
		fi
		choiceMenu="$choiceMenu\n3) \e[1;32mSearch\e[0m"
		if (( pLoc[$pTurn] == pLoc[$pEnemy] )) ; then
			if (( playersKnowEachOther == 0 )) ; then
				choiceMenu="$choiceMenu\n4) \e[1;33mTalk\e[0m"
			else
				choiceMenu="$choiceMenu\n4) \e[1;31mFight\e[0m"
			fi
		else
			choiceMenu="$choiceMenu\n4) \e[35m(no one around)\e[0m"
		fi
	fi
	if (( pControl[$pTurn] == 1 )) ; then
		echo -e $choiceMenu
	fi
}

function GetChoice {
	if (( pControl[$pTurn] == 1 )) ; then
		#Manual Control
		while true; do
			read -rsn1 choice
			if (( gameOver == 0 )) ; then
				case "$choice" in
					1|2|3|4|9) break;;
				esac
			else
				case "$choice" in
					1) break;;
				esac
			fi
		done
	fi
	if (( gameOver == 00 && (pControl[$pTurn] == 2 || choice == 9) )) ; then
		#Automatic Control
		choice=0
		if (( pTurn == 1 )) ; then
			if (( p1MapSearched[${pLoc[$pTurn]}] == 0 )) ; then
				choice=3
			fi
		elif (( pTurn == 2 )) ; then
			if (( p2MapSearched[${pLoc[$pTurn]}] == 0 )) ; then
				choice=3
			fi
		fi
		if (( choice == 0 )) ; then
			if (( pLoc[$pTurn] == pLoc[$pEnemy] )) ; then
				choice=4
			elif (( pLoc[$pTurn] > pLoc[$pEnemy] )) ; then
				choice=2
			elif (( pLoc[$pTurn] < pLoc[$pEnemy] )) ; then
				choice=1
			fi
		fi
	fi
}

function CheckResult {
	if (( gameOver > 0 )) ; then
		if (( pTurn != gameOver )) ; then
			pResult[$pTurn]="You were defeated."
		elif (( pTurn == gameOver )) ; then
			pResult[$pTurn]="You were victorious."
			((gameOver=-gameOver))
		fi
	elif (( choice == 1 )) ; then
		if (( CanGoEast == 1 )) ; then
			pResult[$pTurn]="You walk east."
			if (( pLoc[$pTurn] == pLoc[$pEnemy] )) ; then
				if (( playersKnowEachOther == 1 )) ; then
					pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pTurn]} has left to the east."
				else
					if (( pGender[$pTurn] == 1 )) ; then
						pResult[$pEnemy]="${pResult[$pEnemy]}\nA man has left to the east."
					elif (( pGender[$pTurn] == 2 )) ; then
						pResult[$pEnemy]="${pResult[$pEnemy]}\nA woman has left to the east."
					fi
				fi
			fi
			((pLoc[$pTurn]++))
			if (( pLoc[$pTurn] == pLoc[$pEnemy] )) ; then
				if (( playersKnowEachOther == 1 )) ; then
					pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pTurn]} has approached from the west."
				else
					if (( pGender[$pTurn] == 1 )) ; then
						pResult[$pEnemy]="${pResult[$pEnemy]}\nA man has approached from the west."
					elif (( pGender[$pTurn] == 2 )) ; then
						pResult[$pEnemy]="${pResult[$pEnemy]}\nA woman has approached from the west."
					fi
				fi
			fi
		else
			pResult[$pTurn]="You cannot swim that well!"
		fi
	elif (( choice == 2 )) ; then
		if (( CanGoWest == 1 )) ; then
			pResult[$pTurn]="You walk west."
			if (( pLoc[$pTurn] == pLoc[$pEnemy] )) ; then
				if (( playersKnowEachOther == 1 )) ; then
					pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pTurn]} has left to the west."
				else
					if (( pGender[$pTurn] == 1 )) ; then
						pResult[$pEnemy]="${pResult[$pEnemy]}\nA man has left to the west."
					elif (( pGender[$pTurn] == 2 )) ; then
						pResult[$pEnemy]="${pResult[$pEnemy]}\nA woman has left to the west."
					fi
				fi
			fi
			((pLoc[$pTurn]--))
			if (( pLoc[$pTurn] == pLoc[$pEnemy] )) ; then
				if (( playersKnowEachOther == 1 )) ; then
					pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pTurn]} has approached from the east."
				else
					if (( pGender[$pTurn] == 1 )) ; then
						pResult[$pEnemy]="${pResult[$pEnemy]}\nA man has approached from the east."
					elif (( pGender[$pTurn] == 2 )) ; then
						pResult[$pEnemy]="${pResult[$pEnemy]}\nA woman has approached from the east."
					fi
				fi
			fi
		else
			pResult[$pTurn]="You cannot swim that well!"
		fi
	elif (( choice == 3 )) ; then
		if (( pTurn == 1 )) ; then
			p1MapSearched[${pLoc[$pTurn]}]=1
		elif (( pTurn == 2 )) ; then
			p2MapSearched[${pLoc[$pTurn]}]=1
		fi
		if (( mapItem[${pLoc[$pTurn]}] == 1 )) ; then
			mapItem[${pLoc[$pTurn]}]=0
			pResult[$pTurn]="You got a strong banana! (+2 STR)"
			((pStr[$pTurn]+=2))
		elif (( mapItem[${pLoc[$pTurn]}] == 2 )) ; then
			mapItem[${pLoc[$pTurn]}]=0
			pResult[$pTurn]="You got an appetizing apple! (+1 STR, +5 HP)"
			((pStr[$pTurn]++))
			((pHP_max[$pTurn]+=5))
			((pHP_cur[$pTurn]+=5))
		elif (( mapItem[${pLoc[$pTurn]}] == 3 )) ; then
			mapItem[${pLoc[$pTurn]}]=0
			pResult[$pTurn]="You got a wonderful orange! (+2 DEX)"
			((pDex[$pTurn]+=2))
		elif (( mapItem[${pLoc[$pTurn]}] == 4 )) ; then
			mapItem[${pLoc[$pTurn]}]=0
			pResult[$pTurn]="You got a dazzling cherry! (+2 INT)"
			((pInt[$pTurn]+=2))
		elif (( mapItem[${pLoc[$pTurn]}] == 5 )) ; then
			mapItem[${pLoc[$pTurn]}]=0
			pResult[$pTurn]="You got a miracle kiwi! (+1 DEX, +1 INT)"
			((pDex[$pTurn]++))
			((pInt[$pTurn]++))
		else
			pResult[$pTurn]="There is nothing of use here."
		fi
	elif ((choice == 4 )) ; then
		if (( pLoc[$pTurn] == pLoc[$pEnemy] )) ; then
			if (( playersKnowEachOther == 1 )) ; then
				attackType=$((1 + RANDOM % 1 + pFury[$pTurn]))
				if (( attackType == 1 )) ; then
					if (( 1000 * RANDOM / 32767 < (1000*pDex[$pTurn]) / (pDex[$pTurn]+pDex[$pEnemy]) )) ; then
						pResult[$pTurn]="You hit ${pName[$pEnemy]} for ${pStr[$pTurn]} damage!"
						pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pTurn]} hits you for ${pStr[$pTurn]} damage!"
						((pHP_cur[$pEnemy]-=pStr[$pTurn]))
						((pFury[$pEnemy]++))
					else
						pResult[$pTurn]="You swing at ${pName[$pEnemy]} but miss!"
						pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pTurn]} swings at you but misses!"
					fi
				else
					((pFury[$pTurn]--))
					pResult[$pTurn]="You cast ${pSpell[$pTurn]} and hit ${pName[$pEnemy]} for $((2 * pInt[$pTurn])) damage!"
					pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pTurn]} casts ${pSpell[$pTurn]} and hits you for $((2 * pInt[$pTurn])) damage!"
					((pHP_cur[$pEnemy]-=2*pInt[$pTurn]))
				fi
				if (( pHP_cur[$pEnemy] <= 0 )) ; then
					pResult[$pTurn]="${pResult[$pTurn]}\n${pName[$pEnemy]} was defeated!"
					pResult[$pEnemy]="${pResult[$pEnemy]}\nYou were defeated!"
					gameOver=$pTurn
				fi
			else
				pResult[$pTurn]="${pName[$pTurn]}: \"\e[33mHello stranger, my name is ${pName[$pTurn]}, what's your name?\e[0m\""
				pResult[$pTurn]="${pResult[$pTurn]}\n${pName[$pEnemy]}: \"\e[33mMy name is ${pName[$pEnemy]} and I am going to KILL YOU!\e[0m\""
				pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pTurn]}: \"\e[33mHello stranger, my name is ${pName[$pTurn]}, what's your name?\e[0m\""
				pResult[$pEnemy]="${pResult[$pEnemy]}\n${pName[$pEnemy]}: \"\e[33mMy name is ${pName[$pEnemy]} and I am going to KILL YOU!\e[0m\""
				playersKnowEachOther=1
			fi
		else
			pResult[$pTurn]="You're alone right now!"
		fi
	fi
}

function showIntro {
	clear
	echo
	echo -e " \e[1;33m====================================="
	echo " |                                   |"
	echo " |  Return to the Island of Eternity |"
	echo " |                                   |"
	echo " ====================================="
	echo " |                                   |"
	echo " | You came back for more, but you   |"
	echo " | are better, faster, stronger.     |"
	echo " |                                   |"
	echo " | But then again, so are those who  |"
	echo " | would oppose you.                 |"
	echo " |                                   |"
	echo " | Are you strong enough to win?     |"
	echo " |                                   |"
	echo -e " =====================================\e[0m"
	echo
	echo "   Press any key to begin!"
	read -rsn1
}

function showOutro {
	clear
	echo
	echo -e " \e[1;33m====================================="
	echo " |                                   |"
	if (( gameOver != 0 )) ; then
		echo " |                                   |"
		tput cup 3 3
		echo -e "\e[32m${pName[$pTurn]} Wins!\e[33m"
		echo " |                                   |"
		if (( pGender[$pTurn] == 1 )) ; then
			echo " | He was strong and won.            |"
		elif (( pGender[$pTurn] == 2 )) ; then
			echo " | She was strong and won.           |"
		fi
		echo " |                                   |"
		echo " ====================================="
		echo " |                                   |"
		echo " |                                   |"
		tput cup 9 3
		echo -e "\e[31m${pName[$pEnemy]} was defeated.\e[33m"
		echo " |                                   |"
		if (( pGender[$pEnemy] == 1 )) ; then
			echo " | He was weak and lost.             |"
		elif (( pGender[$pEnemy] == 2 )) ; then
			echo " | She was weak and lost.            |"
		fi
		echo " |                                   |"
		echo " ====================================="
		echo " |                                   |"
		echo " | Try again for more fun!           |"
	else
		echo " |  Breaking the Island of Eternity  |"
		echo " |                                   |"
		echo " ====================================="
		echo " |                                   |"
		echo " | You broke the game.               |"
		echo " |                                   |"
		echo " |                                   |"
		echo " | Bad you.                          |"
		echo " |                                   |"
		echo " |                                   |"
		echo " | Bad.                              |"
	fi
	echo " |                                   |"
	echo -e " =====================================\e[0m"
	echo
	echo "   Press [enter] key to end."
	read -rs
}

tput smcup
tput civis

preparePlayers
prepareMap
showIntro

mainLoop

showOutro

tput cnorm
tput rmcup
