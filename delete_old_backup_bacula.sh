#!/bin/sh

###################################### SCRIPT INFORMATION ######################################################
# Name: delete_old_backup_bacula                                                                               #
# Objective: Delete old backups from bacula.                                                                   #
# Author: Carlos Augusto Moreno R. Junior                                                                      #
# Date: 11-12-2019                                                                                             #
# Last Update: 11-12-2019                                                                                      #
#                                                                                                              #
# Test environment:                                                                                            #
# --> Ubuntu Server                                                                                            #
################################################################################################################

echo "#########################################################################################################"
echo "# One parameter are required to successfully execute the script:                                        #"
echo "# First parameter: Bacula Backup Directory                                                              #"
echo "#                                                                                                       #"
echo "# Example: bash delete_old_backup_bacula.sh /mnt/backup                                                 #"
echo "# Note: No need to put slash at end when entering backup path for Bacula.                               #"
echo "#########################################################################################################"
echo ""

PATH=$1
FILE=$(echo "list media pool=File" | bconsole | cut -f 3 -d '|' | tail -4 | tr -d " " | grep -v -e "+-----" | head -1)

# Delete pool file in Bacula
echo purge volume=$FILE | bconsole

# Delete file in server backup directory
rm -f $PATH/$FILE
