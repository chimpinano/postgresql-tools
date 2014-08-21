#!/bin/bash

if [ -z "$2" ]; then
	echo "usage: $0 filename fulldestpath";
	echo "this script is ment to be run by the postgresqlslave, not by a human"
	exit 2
fi

FILENAME=$1
FILEDEST=$2
export AWS_CONFIG_FILE=/etc/postgresql/9.1/main/awsconfig

#first try todays
TODAY=$(date +%d-%m-%Y)
S3FILENAME="YOURBUCKETNAMEHERE/${TODAY}/incremental/${FILENAME}"
aws 2>/dev/null >/dev/null s3 cp ${S3FILENAME} ${FILEDEST}

if [ $? -eq 0 ]; then
	echo "WAL segment ${FILENAME} successfully imported from todays incrementals on s3"
else
	#if it failed, lets try yesterdays
	YESTERDAY=$(date +%d-%m-%Y --date "1 day ago")
	S3FILENAME="YOURBUCKETNAMEHERE/${YESTERDAY}/incremental/${FILENAME}"
	aws 2>/dev/null >/dev/null s3 cp ${S3FILENAME} ${FILEDEST}

	#if it failed, fail completely
	if [ $? -eq 0 ]; then
		echo "WAL segment ${FILENAME} successfully imported from ${YESTERDAY} incrementals on s3"
	else
		#if it failed, lets try yesterdays
		TWODAYSAGO=$(date +%d-%m-%Y --date "2 day ago")
		S3FILENAME="YOURBUCKETNAMEHERE/bong/${TWODAYSAGO}/incremental/${FILENAME}"
		aws 2>/dev/null >/dev/null s3 cp ${S3FILENAME} ${FILEDEST}

		#if it failed, fail completely
		if [ $? -eq 0 ]; then
			echo "WAL segment ${FILENAME} successfully imported from ${TWODAYSAGO} incrementals on s3"
		else
			echo "WAL segment ${FILENAME} not found on s3 :("
			exit 0
		fi
	fi

fi
