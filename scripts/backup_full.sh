#!/bin/bash

#set -x
#set -e

#local settings
SQLPREFIX="sudo -u postgres psql -c"
SRCROOT="/var/lib/postgresql/9.1/main"
BACKUPROOT="/backups"
FILENAME="full.tar.gz"
PIGZBIN=$(which pigz)
COMPRESSIONLEVEL=5

#uploadsettings
BACKUPEXT="$(date +%d-%m-%Y)/full"
UPLOADBUCKET="YOURBUCKETNAMEHERE"
FULLUPLOADPATH="${UPLOADBUCKET}/${BACKUPEXT}/${FILENAME}"

echo "starting backup at: $(date)"

#make the destination folder
mkdir -p ${BACKUPROOT}
chmod 755 ${BACKUPROOT}

##state that we are gonna do a backup
if [ "${1}" == master ]; then
	${SQLPREFIX} "SELECT pg_start_backup('full', true);"
else
	service postgresql stop;
fi

##make the backup
#fist create a local tar, then paralel gzip it (faster)
tar 2>/dev/null -pcf ${BACKUPROOT}/${FILENAME} ${SRCROOT} --exclude "${SRCROOT}/pg_xlog/*" --exclude "${SRCROOT}/postmaster.pid" --use-compress-program="${PIGZBIN}"

#change the permissions so that user ubuntu has access to it
chmod 755 ${BACKUPROOT}/${FILENAME}

#upload the file to s3
export AWS_CONFIG_FILE=/etc/postgresql/9.1/main/awsconfig
sudo -u ubuntu -E aws s3 cp ${BACKUPROOT}/${FILENAME} ${FULLUPLOADPATH} && rm ${BACKUPROOT}/${FILENAME}

##sate that we are done
if [ "${1}" == master ]; then
	${SQLPREFIX} "SELECT pg_stop_backup();"
else
	service postgresql start;
fi

echo "backup complete at: $(date)"
