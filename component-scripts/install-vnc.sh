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
if [ -z "$VNC_USER" ]
then
    read -p "Enter VNC user: " VNC_USER
fi

if [ `whoami` = root ];
then
    echo "This should not be run as root, please try again without using sudo."
    exit 1
fi

if rpm -qa | grep tigervnc-server ;
then
    echo "VNC Server is already on this system"
    exit 1
else
    sudo yum install tigervnc-server -y
    echo "Set the password for accessing VNC Server: "
    vncpasswd

    # Copy template config file and replace values with Oracle Linux VM username
    sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@\:$VNC_DISPLAY_NUM.service
    sudo sed -i "s/<USER>/$VNC_USER/g" /etc/systemd/system/vncserver@\:$VNC_DISPLAY_NUM.service

    # Reload, start, and enable VNC Server
    sudo systemctl daemon-reload
    sudo systemctl start vncserver@\:$VNC_DISPLAY_NUM.service
    sudo systemctl enable vncserver@\:$VNC_DISPLAY_NUM.service

    # Install desktop environment
    sudo yum groupinstall "server with gui" -y
    sudo systemctl set-default graphical.target
    sudo systemctl restart vncserver@\:$VNC_DISPLAY_NUM.service

    # Configure firewall
    echo "Adding service..."
    sudo firewall-cmd --zone=public --add-service=vnc-server
    sudo firewall-cmd --zone=public --add-service=vnc-server --permanent
    echo "Adding port..."
    sudo firewall-cmd --zone=public --add-port=$VNC_PORT/tcp
    sudo firewall-cmd --zone=public --add-port=$VNC_PORT/tcp --permanent
fi