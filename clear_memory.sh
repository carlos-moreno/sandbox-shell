#!/bin/sh

# Name: clear_memory
# Function: Clear cache memory used on system
# Author: Carlos Augusto Moreno Ribeiro Junior
# Date: 11-08-2019

PATH="/bin:/usr/bin:/usr/local/bin"

# Max Percentage
PERCENT=80

# Total Memory:
T_RAM=`grep -F "MemTotal:" < /proc/meminfo | awk '{print $2}'`
# Free memory:
L_RAM=`grep -F "MemFree:" < /proc/meminfo | awk '{print $2}'`

# RAM used by the system:
U_RAM=`expr $T_RAM - $L_RAM`

# Percentage of RAM used by the system:
P_USED=`expr $U_RAM \* 100 / $T_RAM`

echo ================================================================
date
echo
echo "Memory Used: $P_USED %";

if [ $P_USED -gt $PERCENT ];
  then
    DATE=`date`
    echo $DATE >> /var/log/memoria.log
    echo "Memory Used: $P_USED %" >> /var/log/memoria.log

    echo "Memory above $PERCENT %, cache has been cleared.";
    sync
    # Dropping cache:
    echo 3 > /proc/sys/vm/drop_caches

    for i in {`cat /etc/os-release | grep -e "^ID" | awk -F "=" '{print $2}'`};
    do
      if [ $i == "debian" ] || [ $i == "ubuntu" ];
      then
        sysctl -w vm.drop_caches=3
      fi
    done

    echo
    free -m
    echo
    echo ================================================================
  elif [ $P_USED -lt $PERCENT ];
    then
      echo "Task not performed, amount of memory used is within standard.";
      echo "Percentage of memory to use for task execution: > $PERCENT%"
      echo ================================================================
      unset PERCENT T_RAM L_RAM U_RAM P_USED
      exit $?
  else
    echo "Could not perform task!";
    echo ================================================================
    unset PERCENT T_RAM L_RAM U_RAM P_USED
    exit $?
fi
