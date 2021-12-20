#!/bin/bash
#Change this IP address to the IP address of your VPN.
scanIPAddress="8.8.8.8"
ipchrlen=${#scanIPAddress}
#Ideally you should forward a different port to your VPN's port, 1723 is the default for PPTP VPN.
scanPort="1723"
portchrlen=${#scanPort}

echo -e "\e[0m"
echo "================================"
echo -e "| \e[1;32mDarren's VPN Diagnostic Tool\e[0m |"
echo "================================"
echo -en "| \e[1;35mIP Address:  "
while (( ipchrlen < 15 )) ; do
	((ipchrlen++))
	echo -n " "
done
echo -e "\e[1;33m$scanIPAddress\e[0m |"
echo -en "| \e[1;35mPort:               "
while (( portchrlen < 5 )) ; do
	((portchrlen++))
	echo -n " "
done
echo -e "\e[1;36m$scanPort\e[0m    |"
echo "================================"
echo
sleep 1
echo -e "\e[0mPinging $scanIPAddress..."
PINGRESULT=$(ping -c 1 $scanIPAddress)
echo -ne "\e[1mPing Status:\e[0m "
if [ $? == 0 ] ; then
	echo -e "\e[1;92mGOOD\e[0m"
	failedPing=0
else
	echo -e "\e[1;31mBAD\e[0m"
	failedPing=1
fi
echo
if (( failedPing )) ; then
	echo "Error: No ping response."
	echo "You were unable to ping the server."
	echo "- Ensure your computer and the server are connected to the internet."
	echo "- Ensure the server's IP address hasn't changed."
	echo
	echo "Press any key to end."
	read -rsn1
	exit 1
fi
sleep 1

echo "Checking if port $scanPort is open..."
nc -z -w 1 $scanIPAddress $scanPort
echo -ne "\e[1mPort Status:\e[0m "
if [ $? == 0 ] ; then
	echo -e "\e[1;92mGOOD\e[0m"
	failedPort=0
else
	echo -e "\e[1;31mBAD\e[0m"
	failedPort=1
fi

echo
if (( failedPort )) ; then
	echo "Error: Port not open."
	echo "The port seems closed."
	echo "- Ensure the computer inside the target network is turned on."
	echo "- Ensure the router is routing to the correct internal IP address."
	echo
	echo "Press any key to end."
	read -rsn1
	exit 2
else
	echo "It looks like everything's okay!"
	echo "If the connection's slow it's _probably just lag_."
	echo "- Check whether you're downloading anything."
	echo "- It may be a busy time of the day."
fi
sleep 1

echo
echo "Press any key to end."
read -rsn 1
