#!/bin/bash

source ./common.sh
appname=frontend
root
nginx_setup


systemctl enable nginx  &>>$log_file
systemctl start nginx 
Validate $? "Enabled and started nginx"

rm -rf /usr/share/nginx/html/* 
Validate $? "remove default content"

curl -o /tmp/$appname.zip https://roboshop-artifacts.s3.amazonaws.com/$appname-v3.zip &>>$log_file
cd /usr/share/nginx/html &>>$log_file

unzip /tmp/frontend.zip &>>$log_file
Validate $? "code and unzipping"

rm -rf /etc/nginx/nginx.conf

cp $current_path/nginx.conf /etc/nginx/nginx.conf &>>$log_file
Validate $? "configuration added"

systemctl restart nginx 
Validate $? "restarting"

total_time_taken