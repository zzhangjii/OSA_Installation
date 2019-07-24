#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)

# Extract dependencies to designated directories
echo "Extracting jdk..."
tar -C $opc_path/java -zxf dependencies/jdk-8u131-linux-x64.tar.gz
echo "Extracting kafka..."
tar -C $opc_path/kafka -zxf dependencies/kafka_2.12-2.3.0.tgz
echo "Extracting spark..."
tar -C $opc_path/spark -zxf dependencies/spark-2.2.1-bin-hadoop2.7.tgz
echo "Extracting osa..."
unzip -q dependencies/V978767-01.zip -d $opc_path/osa