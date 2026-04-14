#!/bin/bash

source ./common.sh
appname=rabbitmq
root


cp $current_path/rabitmq.repo /etc/yum.repos.d/rabbitmq.repo
Validate $? "creating repo"

dnf install rabbitmq-server -y &>>$log_file
Validate $? "installing rabitmq"

systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server
Validate $? "enabling starting"

rabbitmqctl add_user roboshop roboshop123 &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
Validate $? "created user and given permissions"

total_time_taken