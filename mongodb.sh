#!/bin/bash

source ./common.sh

root

cp mongo.repo /etc/yum.repos.d/mongo.repo
Validate $? "copying mongorepo"

dnf install mongodb-org -y &>>$log_file
Validate $? "installing mongodb"

systemctl enable mongod &>>$log_file
systemctl start mongod &>>$log_file
Validate $? "enabling and starting"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
Validate $? "connecting to all user"

systemctl restart mongod &>>$log_file
Validate $? "restarting "

total_time_taken