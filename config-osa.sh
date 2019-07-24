#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

opc_path=($PWD)
# opc_path=(/home/opc)
osa_etc=($opc_path/osa/OSA-18.1.0.0.1/osa-base/etc)
osa_spark_home=($opc_path/spark/spark-2.2.1-bin-hadoop2.7)
osa_java_home=($opc_path/java/jdk1.8.0_131)

# Set SPARK_HOME and JAVA_HOME
sed -i "/^SUPPORTED_JAVA_VERSION.*/a SPARK_HOME=\"$osa_spark_home\"\nJAVA_HOME=\"$osa_java_home\"" $osa_etc/osa-env.sh
# Configure database parameters
#$osa_etc/jetty-osa-datasource.xml