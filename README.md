# OSX Server Backup Script
This repo consists of our backup solution for OSX Servers in the SMS Environment.

This script creates a tarball of / of an OSX server on a remote file share. Includes a launchd script for automatically running.

## Requirements

* OSX Server
* SMS Environment

## Install

### Script

The script does the bulk work of running the backup.
Installing the script on a server is quite simple:

```
sudo mkdir -p /Library/stmarg/scripts/backup/
sudo cp osx_server_backup.sh /Library/stmarg/scripts/backup/
sudo chmod +x /Library/stmarg/scripts/backup/osx_server_backup.sh
```

### LaunchDaemon Script

These steps install the LaunchDaemon Script which will run by default every week on Monday at 12:05.

```
sudo cp ca.stmarg.osxserverbackup.plist /Library/LaunchDaemons/
sudo launchctl load -w /Library/LaunchDaemons/ca.stmarg.osxserverbackup.plist
```

### Configuration 

There are only two files in this repo. To manage backup configuration options, edit the rsync_osx_backup.sh script under variables:

```
# VARIABLES
BACKUPSERVER="**********"
BACKUPFOLDER="**********"
ACCOUNT="**********"
PASSWORD="**********"
MAILTO="**********"
```

To edit the times that the script runs, edit the Launch Daemon plist file:

```
<key>Minute</key><integer>05</integer>
<key>Hour</key><integer>00</integer>
<key>WeekDay</key><integer>1</integer>
``` 

## Running Manually/Testing

You can run the script manually by running the command:

```
sudo /Library/stmarg/scripts/backup/osx_server_backup.sh
```