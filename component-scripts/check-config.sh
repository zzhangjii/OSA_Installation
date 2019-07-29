#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
#opc_path=(/home/opc)
config_path=$PWD/../config.txt

if [ -f "$config_path" ];
then
    :
else
    echo "Creating config file..."
    printf "DB_IP=\nDB_PORT=\nDB_SERVICE_NAME=\nOSA_DB_USER=\nVNC_DISPLAY_NUM=\nVNC_PORT=\nVNC_USER=" > $config_path
fi

source $config_path

checkNull(){
    if [ -z "$2" ]
    then
        read -p "Please enter the $1: " temp_var
        sed -i "/^$1/s/=.*/=$temp_var/" $config_path
    fi
}

reset(){
    read -p "Please enter the $1: " temp_var
    sed -i "/^$1/s/=.*/=$temp_var/" $config_path
}

checkNull DB_IP $DB_IP
checkNull DB_PORT $DB_PORT
checkNull DB_SERVICE_NAME $DB_SERVICE_NAME
checkNull OSA_DB_USER $OSA_DB_USER
checkNull VNC_DISPLAY_NUM $VNC_DISPLAY_NUM
checkNull VNC_PORT $VNC_PORT
checkNull VNC_USER $VNC_USER

loop=1
while [ $loop == 1 ]
do
    cat $config_path
    read -p "Please verify these parameters. Are they all correct? (y/n): " verified
    if [[ $verified == [yY] || $verified == [yY][eE][sS] ]]
    then
        echo "Configuration parameters confirmed."
        loop=0
    else
        reset DB_IP $DB_IP
        reset DB_PORT $DB_PORT
        reset DB_SERVICE_NAME $DB_SERVICE_NAME
        reset OSA_DB_USER $OSA_DB_USER
        reset OSA_DB_PWD $OSA_DB_PWD
        reset VNC_DISPLAY_NUM $VNC_DISPLAY_NUM
        reset VNC_PORT $VNC_PORT
        reset VNC_USER $VNC_USER
    fi
done