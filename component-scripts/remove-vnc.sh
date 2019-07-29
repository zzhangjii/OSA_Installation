#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

config_path=$PWD/../config.txt
source $config_path

if [ -z "$VNC_DISPLAY_NUM" ]
then
    read -p "Enter VNC display number: " VNC_DISPLAY_NUM
fi
if [ -z "$VNC_PORT" ]
then
    read -p "Enter VNC port number: " VNC_PORT
fi

sudo firewall-cmd --zone=public --remove-port=$VNC_PORT/tcp --permanent
sudo firewall-cmd --zone=public --remove-service=vnc-server --permanent
sudo yum groupremove "server with gui" "GNOME"
sudo yum remove tigervnc-server
sudo yum remove tigervnc-server-minimal
sudo rm /etc/systemd/system/vncserver@\:$VNC_DISPLAY_NUM.service