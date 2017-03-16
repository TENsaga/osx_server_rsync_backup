#!/bin/bash
## OSX Server Backup Script
## Description: This script will backup an OSX server in the SMS environment.
## Author: Chris Swanson

# VARIABLES
BACKUPSERVER="merlin.stmarg.net"
BACKUPFOLDER="macexport$"
DOMAIN="STMARG"
ACCOUNT="**********"
PASSWORD="**********"
MAILTO="**********"


# OTHER VARIABLES
HOSTNAME=`hostname | awk -F'.' '{ print $1 }'`
DATE=`date +%Y-%m-%d`
FILENAME="$HOSTNAME - $DATE.tar.gz"

# MOUNT BACKUP SHARE
mkdir /Volumes/backup
mount -t smbfs //'$DOMAIN;'$ACCOUNT:$PASSWORD''@$BACKUPSERVER/$BACKUPFOLDER /Volumes/backup

printf "$HOSTNAME - OS X Server Backup -> smb://$BACKUPSERVER/$BACKUPFOLDER/$HOSTNAME\n" > /tmp/msg.txt

if [ ! -d /Volumes/backup/$HOSTNAME ]; then
    printf ">Mount unsuccessful, backup failed\n" >> /tmp/msg.txt
    mail -s "SMS SCRIPTS: $DATE $HOSTNAME - WARNING: Weekly Backup Failed" $MAILTO < /tmp/msg.txt
    echo "Backup Failed"
elif [ -d /Volumes/backup/$HOSTNAME ]; then

	# Removal of older backups
	printf ">Removing older backups\n" >> /tmp/msg.txt
	rm -rfv /Volumes/backup/$HOSTNAME/* >> /tmp/msg.txt
	printf ">Removing older backups complete\n" >> /tmp/msg.txt
	
	printf ">Mount successful, beginning tar backup of /\n" >> /tmp/msg.txt
 
    START=`date +%s`
     
	tar -cpzf "/Volumes/backup/$HOSTNAME/$FILENAME" --directory=/ \
		--exclude "Volumes" \
		--exclude "Groups" \
		--exclude "private" \
		--exclude "dev" \
		--exclude ".Trashes" \
		--exclude ".DocumentRevisions-*" \
		--exclude ".Spotlight-*" \
		--exclude ".fseventsd" \
		--exclude ".file" \
		--exclude ".hotfiles.btree" \
		/  # root
		     
	END=`date +%s`
	DIFF=$(($END-$START))
	printf "\nElapsed Time: $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds.\n" >> /tmp/msg.txt    
	umount -f /Volumes/backup

	printf ">Tar backup complete\n" >> /tmp/msg.txt
	/usr/bin/mail -s "SMS SCRIPTS: $DATE $HOSTNAME - Weekly Backup Finished" $MAILTO < /tmp/msg.txt
fi

# REMOVE TEMP MSG FILE
rm /tmp/msg.txt