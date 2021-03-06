#!/bin/bash
function monitor()
{

	echo "***************************************"
	echo "***************************************"
	echo "**                                   **"
	echo "**   Name: Azeite Chaleca            **"
	echo "**   Student ID: S1719009            **"
	echo "**   Assignment: Monitor Script      **"
	echo "**   Module: Systems Programming     **"
	echo "**                                   **"	
	echo "***************************************"
	echo "***************************************"
	echo "********MONITORING THE TrashCan********"
	local count1
	local count2 
	while true
		do
			if find $HOME/.TrashCan -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
				find $HOME/.TrashCan -type f -print0 | xargs -0 md5sum > initial_hashes.md5
			else
				touch initial_hashes.md5
			fi
			sleep 15
			if find $HOME/.TrashCan -mindepth 1 -print -quit 2>/dev/null | grep -q .; then			
				find $HOME/.TrashCan -type f -print0 | xargs -0 md5sum > current_hashes.md5
			else
				touch current_hashes.md5
			fi
			count1=$(wc -c <"initial_hashes.md5")
			count2=$(wc -c <"current_hashes.md5")
			if [[ $count1 -ne 0 ]] || [[ $count2 -ne 0 ]]; then 
				while IFS=" " read -r initial_hash name; do
		  			if [[ ! -e "$name" ]]; then
		     				echo "$(date +"%F %R") The file $name removed from the this directory!"
		  			else
		  				while IFS=" " read -r current_hash name1; do
		  					if [[ "$name" == "$name1" ]]; then
		   						if [[ "$initial_hash" != "$current_hash" ]]; then
		     							echo "$(date +"%F %R") File $name modified!"
		   						fi  
		  					fi
		  					done <current_hashes.md5
		  			fi
					done <initial_hashes.md5
				while IFS=" " read -r current_hash1 name2; do
		 			if ! grep -q "$name2" initial_hashes.md5; then
		   				echo "$(date +"%F %R") File $name2 added the directory!"
		 			fi 
					done <current_hashes.md5
		  fi
					rm initial_hashes.md5
					rm current_hashes.md5
	done
}

trap trapCtrlC SIGINT
trap trapEndMonitor KILL

function trapCtrlC()
{
	echo -e "\r\nYOU HIT *** Ctrl-C ***"
	echo "TERMINATNG THE MONITOR!"		
	exit 130
}

function trapEndMonitor()
{
	kill -9 $1
	echo -e "\r\nMONITOR KILLED!"
}



