#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

# Will need to exit ssh and reconnect to complete install

opc_path=($PWD)
# opc_path=(/home/opc)

$opc_path/make-directories.sh
$opc_path/extract-dependencies.sh
echo "Setting environment variables..."
$opc_path/set-environment-variables.sh
echo "Installing JDK..."
$opc_path/install-jdk.sh
echo "Configuring Spark..."
$opc_path/config-spark.sh
echo "Configuring OSA..."
$opc_path/config-osa.sh
echo "Installing VNC..."
$opc_path/install-vnc.sh

# ** Reboot **
echo "Configuration complete.\nPlease close your SSH connection, reconnect, then run \"master-initialize.sh\" to complete the installation process."