#!/bin/bash

source ./common.sh
appname=shipping

root
appsetup
java_setup
system_setup

dnf install mysql -y  &>>$log_file
Validate $? "Installing MySQL"

mysql -h $mysql_ip -uroot -pRoboShop@1 -e "show databases like 'cities'"
if [ $? -ne 0 ]; then

    mysql -h $mysql_ip -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
    Validate $? "Loaded schema into MySQL"
    mysql -h $mysql_ip -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$log_file
    Validate $? "Loaded user into MySQL"
    mysql -h $mysql_ip -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
    Validate $? "Loaded master.data into MySQL"
else
    echo  "data is already loaded ...  SKIPPING"
fi

app_reset

total_time_taken

