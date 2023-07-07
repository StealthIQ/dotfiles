#!/bin/bash

cd $(dirname $0) 
source Globalconfig;


while true
do
	userInput=0;
	clear;
	echo "Please choose how to change your Mac address:";
	echo "";
	print_good "[1] Change all Mac addresses";
	print_good "[2] Force change all Mac addresses disable interfaces then change the mac";
	print_good "[3] Change to a specific Mac address";
	print_good "[4] Show availabale interfaces";
	print_good "[5] Show assigned Mac addressses";
	print_good "[6] Revert back all Mac to original status";
	print_good "[7] Exit";
	echo "";
	echo "Choose your module :";
	read n
	case $n in
		1) userInput=1;;
		2) userInput=2;;
		3) userInput=3;;
		4) userInput=4;;
		5) userInput=5;;
		6) userInput=6;;
		7) userInput=7;;
		*) print_error "Warning: wrong value";sleep 1;;
	esac


	if [[ $userInput = "7" ]]
	then
		clear;
		print_good "Done!!";
		echo "";
		exit 1;
	fi


	

	if [[ $userInput = "5" ]]
	then
		clear;
		D='/sys/class/net'
		theChangecounter=0;
		for nic in $( ls $D )
		do		
			#if  !(grep -q down $D/$nic/operstate)
			#then							  
				themac=$(cat $D/$nic/address)
				if [ "$themac" != "00:00:00:00:00:00" ] && [ "$themac" != "" ]
				then
				    if (cat $D/$nic/address > /dev/null)
				    then
						theChangecounter=$((theChangecounter+1))	
						themac=$(cat $D/$nic/address);
						echo "Device($theChangecounter): ${cayn}$nic ${reset}Mac: ${cayn}$themac${reset}";
					fi
				
				fi			
						
			#fi
		done
		echo "";
		echo "Total mac addresses found ${green}$theChangecounter";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi

	 
	if [[ $userInput = "4" ]]
	then
		clear;
		theChangecounter=0;
		
		arp -n;
		echo "";
		ip link show;
		echo ""
		sudo lshw -class network -short
		echo "";
		
		for i in $( nmcli device status | awk '{print $1}' );
		do
		if [ $i != "DEVICE" ] && [ $i != "lo" ]
		then
			theChangecounter=$((theChangecounter+1));
			echo "Device($theChangecounter): ${cayn}$i${reset}";		

		fi
		done
		
		echo "Total devices found ${green}$theChangecounter";
		
		#nmcli connection show;
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
		
		
		
		
	fi

	if [[ $userInput = "3" ]]
	then
		clear;
		echo "";
		print_good "Please type in the interface name you would like to change the mac address :";
		read n
		sudo macchanger -r $n
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi


	



	if [[ $userInput = "1" ]]
	then
		
		clear;
		D='/sys/class/net'
		theChangecounter=0;
		for nic in $( ls $D )
		do		
			if (cat $D/$nic/address > /dev/null)
			then
											
				themac=$(cat $D/$nic/address)
				if [ "$themac" != "00:00:00:00:00:00" ] && [ "$themac" != "" ]
				then
					if(sudo timeout 10 sudo macchanger -r $nic)
					then
					    print_good "Mac changed for $nic";
						theChangecounter=$((theChangecounter+1)) 
						echo "";
					fi
				fi
			
			fi	
		done
			
		

		if [[ $theChangecounter == 0 ]]
		then
			
			print_error "Mac address could not be changed";
			
		fi


		echo "";
		echo "Total mac addresses changed ${green}$theChangecounter${reset}";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
		
		
	fi
	
	
	
	
	
	if [[ $userInput = "2" ]]
	then
		clear;
		
		
		for intf in /sys/class/net/*; do
			echo "Taking ${green}$intf${reset} down";
			sudo ifconfig `basename $intf` down;
		done
        echo "";
		#sudo service tor stop > /dev/null;
		#sudo service openvpn stop > /dev/null; 
		#sudo killall tor > /dev/null;
		#sudo killall openvpn > /dev/null;
		#sudo service network-manager stop > /dev/null;
		 
		D='/sys/class/net'
		theChangecounter=0; 
		for nic in $( ls $D )
		do		
			if (cat $D/$nic/address > /dev/null)
			then
											
				themac=$(cat $D/$nic/address)
				if [ "$themac" != "00:00:00:00:00:00" ] && [ "$themac" != "" ]
				then
					if(sudo timeout 10 sudo macchanger -r $nic)
					then
					    print_good "Mac changed for $nic";
						theChangecounter=$((theChangecounter+1)) 
						echo "";
					fi
				fi
			
			fi	
		done
			
		#echo $theChangecounter;

		if [[ $theChangecounter == 0 ]]
		then
			
			print_error "Mac address could not be changed";
			
		fi
		
		for intf in /sys/class/net/*; do
			echo "Taking ${green}$intf${reset} up";
			sudo ifconfig `basename $intf` up;
		done
		
		#sudo service network-manager restart;


		echo "";
		echo "Total mac addresses changed = ${green}$theChangecounter${reset}";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi
	
	
	
	
	if [[ $userInput = "6" ]]
	then
		clear;
		
		
		for intf in /sys/class/net/*; do
			echo "Taking ${green}$intf${reset} Down";
			sudo ifconfig `basename $intf` down;
		done
        echo "";
		#sudo service tor stop > /dev/null;
		#sudo service openvpn stop > /dev/null; 
		#sudo killall tor > /dev/null;
		#sudo killall openvpn > /dev/null;
		#sudo service network-manager stop > /dev/null;
		 
		D='/sys/class/net'
		theChangecounter=0; 
		for nic in $( ls $D )
		do		
			if (cat $D/$nic/address > /dev/null)
			then
											
				themac=$(cat $D/$nic/address)
				if [ "$themac" != "00:00:00:00:00:00" ] && [ "$themac" != "" ]
				then
					if(sudo timeout 10 sudo macchanger -p $nic)
					then
					    print_good "Mac changed for $nic";
						theChangecounter=$((theChangecounter+1)) 
						echo "";
					fi
				fi
			
			fi	
		done
			
		#echo $theChangecounter;

		if [[ $theChangecounter == 0 ]]
		then
			
			print_error "Mac address could not be changed";
			
		fi
		
		for intf in /sys/class/net/*; do
			echo "Taking ${green}$intf${reset} up";
			sudo ifconfig `basename $intf` up;
		done
		
		#sudo service network-manager restart;


		echo "";
		echo "Total mac addresses changed ${green}$theChangecounter${reset}";
		echo "";
		read -n 1 -s -r -p "${reset}Press any key to continue.....";
	fi

done
