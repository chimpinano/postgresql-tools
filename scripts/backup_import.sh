#!/bin/bash

if [ -z "$1" ]; then
	DATE=$(date +%d-%m-%Y)
else
	DATE=$1
fi

set -x
set -e

#uploadsettings
UPLOADBUCKET="YOURBUCKETNAMEHERE"
FULLFILENAME="full.tar.gz"
FULLBACKUPSOURCE="${UPLOADBUCKET}/${DATE}/full/${FULLFILENAME}"
LOCALDIR="/var/lib/postgresql/9.1/main"
PIGZBIN=$(which pigz)

#stop postgres
service postgresql stop

#clean the local dir
rm -rf ${LOCALDIR}/*

#download the full backup file of s3
export AWS_CONFIG_FILE=/etc/postgresql/9.1/main/awsconfig
aws s3 cp ${FULLBACKUPSOURCE} ${LOCALDIR}

#extract it
cd ${LOCALDIR}
tar -xf ${FULLFILENAME} --use-compress-program="${PIGZBIN}"
mv ${LOCALDIR}/var/lib/postgresql/9.1/main/* ${LOCALDIR}/
rm -r ${LOCALDIR}/${FULLFILENAME} ${LOCALDIR}/var

#change permissions
chmod -R 0700 ${LOCALDIR}
chown -R postgres:postgres ${LOCALDIR}

#start postgresql
service postgresql start
