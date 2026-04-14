#!/bin/bash

source ./common.sh
root
appname=redis



dnf module disable redis -y &>>$log_file
dnf module enable redis:7 -y &>>$log_file
Validate $? "disabling and enabling"

dnf install redis -y  &>>$log_file
Validate $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
Validate $? "allowing connections"

systemctl enable redis &>>$log_file  
systemctl start redis 
Validate $? "enabling and starting"

total_time_taken