#!/bin/bash

# ------------------------------------------------------------------------------------------------------
# Script Name: install_db_in_docker.sh
# Creation Data: 01/19/2024
# Author: Carlos Moreno
# Revision: 0.1.0
# Description: Install and configure Oracle 23c database in Docker
# Requirement: You need to have docker installed and run the command below
#              chmod +x install_db_in_docker.sh
# Example of use: ./install_db_in_docker.sh
# ------------------------------------------------------------------------------------------------------

echo "Preparing the 'gvenzl/oracle-free:23-slim' container for the appropriate configurations."
docker run -d --name oracle-23c -p 1521:1521 -e ORACLE_PASSWORD="oracle" gvenzl/oracle-free:23-slim

while true; do
    docker exec oracle-23c bash -c "sqlplus -s sys/oracle@localhost:1521/freepdb1 as sysdba << EOF
       set heading off;
       set pagesize 0;
       SELECT 'READY'
        FROM dual;
    EOF" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "Server 'oracle-23c' configured successfully.\n"
        break
    else
        echo "Waiting for server configuration 'oracle-23c'..."
        sleep 1
    fi
done

sleep 2
echo -e "Configuring the Oracle client\n"

curl -o /tmp/client.zip https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip \
     -o /tmp/sqlplus.zip https://download.oracle.com/otn_software/linux/instantclient/instantclient-sqlplus-linuxx64.zip \
     -o /tmp/sql_loader.zip https://download.oracle.com/otn_software/linux/instantclient/instantclient-tools-linuxx64.zip

sudo unzip /tmp/client.zip -d /opt
unzip -u /tmp/sqlplus.zip -d /tmp
unzip -u /tmp/sql_loader.zip -d /tmp
sudo cp /tmp/instantclient_21_13/* /opt/instantclient_21_12

sudo chown -R $USER:$USER /opt

cat << EOF > /opt/instantclient_21_12/network/admin/tnsnames.ora
FREEPDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = FREEPDB1)
    )
  )

EOF

echo "The database is ready."
echo -e "Enjoy!!!\n"
