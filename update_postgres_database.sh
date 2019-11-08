#!/bin/bash
######################## INFORMAÇÕES DO SCRIPT ######################################
# Name: update_postgres_database                                                    #
# Objective: Kill active connections to the postgres database passed as a parameter #
#            and restore it with a backup file                                      #
# Author: Carlos Augusto Moreno R. Junior                                           #
# Date: 11-08-2019                                                                  #
#####################################################################################

FORMAT="%d/%m/%Y %H:%M:%S"
NOW=$(date +"$FORMAT")

echo "##############################################################################"
echo "# Two parameters are required to successfully execute the script:            #"
echo "# First parameter: Enter the name of the database.                           #"
echo "# Second parameter: Enter the location of the backup to be restored.         #"
echo "#                                                                            #"
echo "# Example.: bash update_postgres_database.sh database-name backup-path       #"
echo "# Note: Backup to restore must be in sql format.                             #"
echo "##############################################################################"
echo ""

if [ $# -lt 2 ];
  then
  	echo "Please enter the parameters correctly!"
  	if ! [ $1 ];
      then
  		  echo "==> Base Name is required!"
  	fi

  	if ! [ $2 ];
      then
  		  echo "==> Backup path is required!"
  	fi

  	echo ""
  	echo "############################# End #########################################"
  	exit 1
fi

echo "############### Killing Active Database Connections $1 ==> $NOW ##############"
psql -h localhost -U postgres --command='select pg_terminate_backend(pid) from pg_stat_activity where pid in (select pid from pg_stat_activity where datname = '"'$1'"')'

echo "############### Deleting and Rebuilding the Database $1 ==> $NOW ####################"
psql -h localhost -U postgres --command="drop database $1"
psql -h localhost -U postgres --command="create database $1"

echo "############### Restoring the database ==> $NOW #####"
psql -h localhost -U postgres $1 -f $2

echo "############################# End ==> $NOW #########################################"
