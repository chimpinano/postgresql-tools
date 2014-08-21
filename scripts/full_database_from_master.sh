#!/bin/bash

#set -x

MASTERHOST=$1

if [ -z "${MASTERHOST}" ]; then
	echo "usage: $0 ip-of-master"
	exit 1;
fi

if [ "$(pwd)" == "/var/lib/postgresql/9.1/main" ]; then
	echo "cannot run this script in this folder...."
	exit 1;
fi

echo " ==== MAKE SURE YOU RUN THIS ON A POSTGRESQL SLAVE!!!! ==== "
echo
echo " ==== THIS WILL REMOVE ALL YOUR FILES IN /var/lib/postgresql/9.1/main ==== "
echo
echo " ==== CONTINUING in 10 seconds, press ctrl+c to quit now! ==="
echo

sleep 10

echo "Stopping PostgreSQL"
sudo service postgresql stop

echo "Cleaning up old cluster directory"
sudo -u postgres rm -rf /var/lib/postgresql/9.1/main

echo "Starting base backup as YOURREPLICATORUSERNAME"
sudo -u postgres pg_basebackup -h ${MASTERHOST} -D /var/lib/postgresql/9.1/main -U YOURREPLICATORUSERNAME -v -P

echo "Writing recovery.conf file"
sudo -u postgres bash -c "cat > /var/lib/postgresql/9.1/main/recovery.conf <<- _EOF1_
  standby_mode = 'on'
  primary_conninfo = 'host=${MASTERHOST} port=5432 user=YOURREPLICATORUSERNAME password=YOURREPLICATORPASSWORD sslmode=require'
  trigger_file = '/tmp/postgresql.trigger'
  restore_command = 'bash /path/to/restore_incremental.sh %f %p'
_EOF1_
"
echo Startging PostgreSQL
sudo service postgresql start
