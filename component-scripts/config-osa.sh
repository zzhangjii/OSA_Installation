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

# Prompt for DB parameters if necessary
if [ -z "$DB_IP" ]
then
    read -p "Enter DB public IP: " DB_IP
fi
if [ -z "$DB_PORT" ]
then
    read -p "Enter DB port number: " DB_PORT
fi
if [ -z "$DB_SERVICE_NAME" ]
then
    read -p "Enter DB service name: " DB_SERVICE_NAME
fi
if [ -z "$OSA_DB_USER" ]
then
    read -p "Enter OSA DB user: " OSA_DB_USER
fi

read -s -p "Enter a password for the DB user $OSA_DB_USER: "  db_password

# Configure DB parameters
sed -i "/Set name=\"URL\"/s/myhost.example.com/$DB_IP/" $osa_etc/jetty-osa-datasource.xml
sed -i "/Set name=\"URL\"/s/1521/$DB_PORT/" $osa_etc/jetty-osa-datasource.xml
sed -i "/Set name=\"URL\"/ s|:OSADB|/$DB_SERVICE_NAME|" $osa_etc/jetty-osa-datasource.xml

sed -i "/Set name=\"User\"/s/{OSA_USER}/$OSA_DB_USER/" $osa_etc/jetty-osa-datasource.xml
sed -i "/Set name=\"Password\"/s/{OSA_USER_PWD}/$db_password/" $osa_etc/jetty-osa-datasource.xml