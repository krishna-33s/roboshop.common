#!/bin/bash

source ./common.sh

root
appname=mysql

dnf install mysql-server -y &>>$log_file
Validate $? "Install MySQL server"

systemctl enable mysqld &>>$log_file
systemctl start mysqld  
Validate $? "Enable and start mysql"

mysql_secure_installation --set-root-pass RoboShop@1
Validate $? "Setup root password"

total_time_taken