#!/bin/bash

user_id=$(id -u)
log_folder="/var/log/roboshop.project"
log_file="$log_folder/$0.log"
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"
start_time=$(date +%s)
mongo_ip=mongodb.krishnadev.space
mysql_ip=mysql.krishnadev.space
current_path=$PWD

mkdir -p $log_folder

echo -e "$(date "+%Y-%m-%d %H:%M:%S") | script started at: $g $(date)" | tee -a $log_file

root(){
    if [ $user_id -ne 0 ]; then
        echo -e "$r pls run the script to root user $n" | tee -a $log_file
        exit 1

    fi
}

Validate(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") |$r $2...failed $n" | tee -a $log_file
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") |$g $2...success $n" | tee -a $log_file
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$log_file
    Validate $? "disabling nodejs"

    dnf module enable nodejs:20 -y &>>$log_file
    Validate $? "enabling nodejs:20"

    dnf install nodejs -y &>>$log_file
    Validate $? "installing nodejs"

    npm install &>>$log_file
    Validate $? "downloading dependencies"

}

java_setup(){
    dnf install maven -y &>>$log_file
    Validate $? "Installing Maven"

    cd /app
    mvn clean package &>>$log_file
    Validate $? "Installing and Building $appname"

    mv target/$appname-1.0.jar $appname.jar 
    Validate $? "Moving and Renaming $appname"

}

appsetup(){
    id roboshop &>>$log_file
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file 
        Validate $? "creating user"
    else
        echo "roboshop already exist"
    fi 

    mkdir -p /app
    Validate $? "creating app directory"

    curl -o /tmp/$appname.zip https://roboshop-artifacts.s3.amazonaws.com/$appname-v3.zip &>>$log_file 
    Validate $? "downloading $appname code"

    cd /app
    Validate $? "moving to app directory"

    rm -rf /app/*
    Validate $? "removing default code"

    unzip /tmp/$appname.zip &>>$log_file
    Validate $? "unzipping"
}

system_setup(){
    cp $current_path/$appname.service /etc/systemd/system/$appname.service
    Validate $? "systemctl $appname service"

    systemctl daemon-reload
    systemctl enable $appname &>>$log_file
    systemctl start $appname
    Validate $? "starting and enabling"

}

app_reset(){
    systemctl restart $appname
    Validate $? "Restarting $appname"
}
total_time_taken(){
    end_time=$(date +%s)
    total_time=$(($end_time - $start_time))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | script completed in : $g $total_time in seconds $n" | tee -a $log_file 
}