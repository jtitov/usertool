#!/bin/bash

echo "Create sudo user tool with RSA identity"

function createuser {
	while [ -z "$user" ]; do
	read -p "User name:" user
	done

	read -p "sudo group name [sudo]:" SGRUOP
	if [ -z "$SGROUP" ]; then
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

	while [ -z "$pub" ]; do
	read -p "Paste public key:" pub
	done

	echo "${pub}" > /home/$user/.ssh/authorized_keys

	chmod 700 /home/$user/.ssh
	chmod 600 /home/$user/.ssh/authorized_keys
	chown -R $user:$user /home/$user
}

if [ "$USER" = "root" ]; then 
	
	createuser $1 $2
	if [ $? -ne 0 ]; then
		echo "ERROR:Username is null"
	fi
else 
	echo "ERROR: Run this tool as sudo"
	exit 1
fi


