#!/bin/bash

user_id=$(id -u)
log_folder="/var/log/roboshop.project"
log_file="$log_folder/$0.log"
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"
start_time=$(date +%s)

mkdir -p $log_folder

echo "$(date "+%Y-%m-%d %H:%M:%S") | script started at: $(date)" | tee -a $log_file

root(){
    if [ $user_id -ne 0 ]; then
        echo -e "$r pls run the script to root user" | tee -a $log_file
        exit 1

    fi
}

Validate(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") |$r $2...failed" | tee -a $log_file
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") |$g $2...success" | tee -a $log_file
    fi
}

total_time_taken(){
    end_time=$(date +%s)
    total_time=$(($end_time - $start_time))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | scripts completed in : $g $total_time in seconds" | tee -a $log_file 
}