#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

# Will need to exit ssh and reconnect to complete install

#opc_path=($PWD)
opc_path=(/home/opc)
component_scripts=$PWD/component-scripts

$component_scripts/make-directories.sh
$component_scripts/extract-dependencies.sh
echo "Setting environment variables..."
sudo $component_scripts/set-environment-variables.sh
echo "Installing JDK..."
$component_scripts/install-jdk.sh
echo "Configuring Spark..."
$component_scripts/config-spark.sh
echo "Configuring OSA..."
$component_scripts/config-osa.sh
echo "Installing VNC..."
$component_scripts/install-vnc.sh

# Requests reboot
echo "Configuration complete.\nPlease close your SSH connection, reconnect, then run \"master-initialize.sh\" to complete the installation process."