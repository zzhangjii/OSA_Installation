#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

# Will need to exit ssh and reconnect to complete install

#cd /home/opc
opc_path=($PWD)

$opc_path/make-directories.sh
$opc_path/extract-dependencies.sh
$opc_path/set-environment-variables.sh
$opc_path/install-jdk.sh
$opc_path/config-spark.sh
$opc_path/config-osa.sh
$opc_path/install-vnc.sh


# ** Reboot **



# Start Zookeeper and Kafka server

# Start Spark master

# Start OSA with initialization

# 