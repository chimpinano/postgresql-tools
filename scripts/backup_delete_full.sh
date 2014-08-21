#!/bin/bash

DEFAULT=31

if [ -z "$1" ]; then
        DAYS=${DEFAULT};
else
        DAYS=$1;
fi

HISTORYDAYNUMBER=$(date --date="${DAYS} days ago" +%d)
HISTORYFULLDATE=$(date --date="${DAYS} days ago" +%d-%m-%Y)

UPLOADBUCKET="YOURBUCKETNAMEHERE"
TARGETBUCKET="${UPLOADBUCKET}/${HISTORYFULLDATE}"

if [ ${HISTORYDAYNUMBER} != "01" ]; then
	if [ "${DAYS}" != "31" ]; then
		echo "REMOVING A NON DEFAULT TIMESPAN OF: ${DAYS} DAYS AGO (the default is: ${DEFAULT}), PRESS CTRL+C IN THE NEXT 10 SECONDS TO STOP"
		sleep 10
	fi

	echo "removing ${TARGETBUCKET}";

	export AWS_CONFIG_FILE=/etc/postgresql/9.1/main/awsconfig
	aws s3 rm ${TARGETBUCKET} --recursive
else
	echo "${TARGETBUCKET} is a first of the month, ignoring"
fi
