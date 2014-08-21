#!/bin/bash

if [ -z "$2" ]; then
	echo "usage: $0 fullsourcepath filename";
	echo "this script is ment to be run by the postgresqlmaster, not by a human"
	exit 2
fi

#set -x
#set -e

#uploadsettings
BACKUPSRC="/var/lib/postgresql/9.1/main/$1"
FILENAME=$2
BACKUPEXT="$(date +%d-%m-%Y)/incremental"
UPLOADBUCKET="YOURBUCKETNAMEHERE"
FULLUPLOADPATH="${UPLOADBUCKET}/${BACKUPEXT}/${FILENAME}"

#upload the file to s3
export AWS_CONFIG_FILE=/etc/postgresql/9.1/main/awsconfig
aws s3 cp ${BACKUPSRC} ${FULLUPLOADPATH}
