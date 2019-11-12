#!/bin/sh

###################################### SCRIPT INFORMATION ######################################################
# Name: check_zimbra_account_usage                                                                             #
# Objective: Check zimbra usage by verifying a text file with access data generated by the zmaccts command.    #
# Author: Carlos Augusto Moreno R. Junior                                                                      #
# Date: 11-11-2019                                                                                             #
################################################################################################################

echo "#########################################################################################################"
echo "# Two parameters are required to successfully execute the script:                                       #"
echo "# First parameter: Enter a reference date.                                                              #"
echo "# Second parameter: Text file containing access data.                                                   #"
echo "#                                                                                                       #"
echo "# Example: bash check_zimbra_account_usage.sh 01/06/19 arquivo.txt                                      #"
echo "# Note: To create the zimbra usage file, simply use the zmaccts command and filter any status.          #"
echo "#       The script in question uses the idea of ​​active users.                                           #"
echo "# Example: zmaccts | grep active                                                                        #"
echo "#########################################################################################################"
echo ""

if [ $# -lt 2 ];
  then
  	echo "Please enter the parameters correctly!"
  	if ! [ $1 ];
      then
  		  echo "==> Reference Date is required!"
  	fi

  	if ! [ $2 ];
      then
  		  echo "==> Text file is required!"
  	fi

  	echo ""
  	echo "######################################## End ########################################################"
  	exit 1
fi


echo "============================================ ACTIVE ====================================================="

while read line;
do
    if [ $(date -d $(echo -e $line | awk '{print $3}') +%s) -ge $1 ];
    then
        echo -e $line >> active_emails.txt
    fi
done < $2

echo "========================================================================================================="

echo "\n"

echo "============================================ INACTIVE ==================================================="

while read line;
do
    if [ $(date -d $(echo -e $line | awk '{print $3}') +%s) -lt $1 ];
    then
        echo -e $line >> inactive_emails.txt
    fi
done < $2

echo "========================================================================================================="
