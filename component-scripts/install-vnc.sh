#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

if rpm -qa | grep tigervnc-server ;
then
    echo "VNC Server is already on this system"
    exit 1
else
    read -p "Enter display number: "  display_number
    read -p "Enter port number: "  port
    read -p "Enter VNC user: " vnc_user

    sudo yum install tigervnc-server
    vncpasswd

    # Copy template config file and replace values with Oracle Linux VM username
    sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@\:$display_number.service
    sed -i "s/<USER>/$vnc_user/g" /etc/systemd/system/vncserver@\:$display_number.service

    # Reload, start, and enable VNC Server
    sudo systemctl daemon-reload
    sudo systemctl start vncserver@\:$display_number.service
    sudo systemctl enable vncserver@\:$display_number.service

    # Install desktop environment
    sudo yum groupinstall "server with gui"
    sudo systemctl set-default graphical.target
    sudo systemctl restart vncserver@\:$display_number.service

    # Configure firewall
    echo "Adding service..."
    sudo firewall-cmd --zone=public --add-service=vnc-server
    sudo firewall-cmd --zone=public --add-service=vnc-server –permanent
    echo "Adding port..."
    sudo firewall-cmd --zone=public --add-port=$port/tcp
    sudo firewall-cmd --zone=public --add-port=$port/tcp –permanent
fi