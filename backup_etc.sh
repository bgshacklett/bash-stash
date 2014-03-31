#!/usr/bin/env bash

#Config Settings
BACKUP_SOURCE='/etc'
BACKUP_DESTINATION_BASE=$HOME/backup/etc
SHORTCUT_BACKUP_CURRENT=$BACKUP_DESTINATION_BASE/current

# Script Logic
date=`date -u "+%Y-%m-%dT%H%M%SZ"`

backupDestination=$BACKUP_DESTINATION_BASE/$date

#Check if we're initializing the backup repo.
if [ $1 == "init" ]; then
        # If so, initialize the repo.
        rsync -aP $BACKUP_SOURCE $backupDestination
else
        #If we're not, ensure it's been initialized, or die with an error.
        if [ -d "$SHORTCUT_BACKUP_CURRENT" ]; then
                rsync -aP --link-dest=$SHORTCUT_BACKUP_CURRENT $BACKUP_SOURCE $backupDestination
        else
                echo "This backup repository hasn't been set up yet. Please run \"${0} init\"." 1>&2;
        fi
fi


ln -sfn $backupDestination $SHORTCUT_BACKUP_CURRENT

