#!/bin/bash

source ./common.sh

appname=catalogue
root
appsetup
nodejs_setup
system_setup
app_reset

cp $current_path/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
dnf install mongodb-mongosh -y &>>$log_file


INDEX=$(mongosh --host $mongo_ip --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $mongo_ip </app/db/master-data.js
    Validate $? "Loading products"
else
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") |$g Products already loaded ... $r SKIPPING $n"
fi

systemctl restart catalogue
Validate $? "Restarting catalogue"

total_time_taken