#!/bin/bash

echo "Create sudo user tool with RSA identity"

function createuser {
	if [ -z "$1" ]; then
		return 1
	else
		user=$1
	fi
	if [ -n "$2" ]; then
		SGROUP=$2
	else
		SGROUP=sudo
	fi
	echo "Creating new user: ${user}, with membeship sudo group ${SGROUP}"
	useradd -G ${SGROUP} -d /home/$user -s /bin/bash -m $user
	if [ $? -ne 0 ]; then
		echo "Error adding new user!"
		return 1
	fi

	mkdir /home/$user/.ssh
	chmod 700 /home/$user/.ssh
	read -p "Paste public key:" pub
	echo "${pub}" > /home/$user/.ssh/authorized_keys

	chmod 700 /home/$user/.ssh
	chmod 600 /home/$user/.ssh/authorized_keys
	chown -R $user:$user /home/$user
}

if [ "$USER" = "root" ]; then 
	
	createuser $1 $2
	if [ $? -ne 0 ]; then
		echo "Usage tool: sudo ./createuser.sh username [sudo group]"
	fi
else 
	echo "ERROR: Run this tool as sudo"
	exit 1
fi


