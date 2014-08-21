#!/bin/bash

#where can we find credentials
export AWS_CONFIG_FILE=/root/aws_ec2_start_stop

#backup instance id
INSTANCEID=$(aws ec2 describe-instances --filter Name="tag-value",Values="PostgresBackup" --output table | grep InstanceId | awk '{print $4}')

aws ec2 start-instances --instance-ids ${INSTANCEID}
