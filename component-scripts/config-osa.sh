#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)
osa_etc=($opc_path/osa/OSA-18.1.0.0.1/osa-base/etc)
osa_spark_home=($opc_path/spark/spark-2.2.1-bin-hadoop2.7)
osa_java_home=($opc_path/java/jdk1.8.0_131)
config_path=$PWD/../config.txt

source $config_path

# Set SPARK_HOME and JAVA_HOME
sed -i "/^SUPPORTED_JAVA_VERSION.*/a SPARK_HOME=\"$osa_spark_home\"\nJAVA_HOME=\"$osa_java_home\"" $osa_etc/osa-env.sh

# Configure xml file
# Remove comment lines and reformat spaces
sed -i '10d' $osa_etc/jetty-osa-datasource.xml
sed -i '31d' $osa_etc/jetty-osa-datasource.xml
sed -i "/New id=/s/        //" $osa_etc/jetty-osa-datasource.xml

# Prompt for DB parameters
# read -p "Enter DB public IP: "  db_ip
# read -p "Enter DB port number: "  db_port
# read -p "Enter service name: "  service_name
# read -p "Enter OSA DB username: "  db_user
read -s -p "Enter a password for the DB user $OSA_DB_USER: "  db_password

# Configure DB parameters
sed -i "/Set name=\"URL\"/s/myhost.example.com/$db_ip/" $osa_etc/jetty-osa-datasource.xml
sed -i "/Set name=\"URL\"/s/1521/$db_port/" $osa_etc/jetty-osa-datasource.xml
sed -i "/Set name=\"URL\"/ s|:OSADB|/$service_name|" $osa_etc/jetty-osa-datasource.xml

sed -i "/Set name=\"User\"/s/{OSA_USER}/$db_user/" $osa_etc/jetty-osa-datasource.xml
sed -i "/Set name=\"Password\"/s/{OSA_USER_PWD}/$db_password/" $osa_etc/jetty-osa-datasource.xml