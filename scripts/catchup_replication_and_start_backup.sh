#!/bin/bash

echo "wating for replication to catchup at : $(date)"
RETURN=2
while [ ${RETURN} -eq 2 ]; do
	sleep 120;
	bash /path/to/check_postgres_slave_rep_delay_local.sh 2>1;
	RETURN=$?
done

echo "replication delay = 0, waiting for the time to be >=00:00 at: $(date)"
HOUR="23"
while  [ ${HOUR} != "00"  ] &&  [ ${HOUR} != "01" ] && [ ${HOUR} != "02" ] && [ ${HOUR} != "03" ]; do
	sleep 10;
	HOUR=$(date +%H)
done

#we start a new backup
echo "all requirements are met, starting backup at: $(date)"
bash /path/to/backup_full.sh
echo "completed backup job at: $(date)"

echo "stopping myself at: $(date)"

#where can we find credentials
export AWS_CONFIG_FILE=/root/aws_ec2_start_stop

#stop myself
aws ec2 stop-instances --instance-ids $(curl http://169.254.169.254/latest/meta-data/instance-id)
