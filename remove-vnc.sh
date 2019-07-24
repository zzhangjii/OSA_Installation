#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

read -p "Enter display number: "  display_number
read -p "Enter port number: "  port

sudo firewall-cmd --zone=public --remove-port=$port/tcp --permanent
sudo firewall-cmd --zone=public --remove-service=vnc-server --permanent
sudo yum groupremove "server with gui" "GNOME"
sudo yum remove tigervnc-server
sudo yum remove tigervnc-server-minimal
sudo rm /etc/systemd/system/vncserver@\:$display_number.service