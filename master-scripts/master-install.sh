#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

# Will need to exit ssh and reconnect to complete install

#opc_path=($PWD)
opc_path=(/home/opc)
component_scripts=$PWD/../component-scripts

if $component_scripts/make-directories.sh ;
then
    echo "Directories created."
else
    exit 1
fi

if $component_scripts/extract-dependencies.sh ;
then
    echo "Dependencies extracted."
else
    $component_scripts/remove-directories.sh
    exit 1
fi

echo "Setting environment variables..."
if sudo $component_scripts/set-environment-variables.sh ;
then
    echo "Environment variables set."
else
    exit 1
fi

echo "Installing JDK..."
if $component_scripts/install-jdk.sh ;
then
    echo "JDK installed."
else
    exit 1
fi

echo "Configuring Spark..."
if $component_scripts/config-spark.sh ;
then
    echo "Spark configured."
else
    exit 1
fi

echo "Configuring OSA..."
if $component_scripts/config-osa.sh ;
then
    echo "OSA configured."
else
    exit 1
fi

echo "Installing VNC..."
if $component_scripts/install-vnc.sh ;
then
    echo "VNC installed."
else
    exit 1
fi

# Requests reboot
echo "Configuration complete.\nPlease close your SSH connection, reconnect, then run \"master-initialize.sh\" to complete the installation process."