#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)
dependencies_path=$PWD/../dependencies

# Extract dependencies to designated directories
echo "Extracting jdk..."
tar -C $opc_path/java -zxf $dependencies_path/jdk-8u131-linux-x64.tar.gz
echo "Extracting kafka..."
tar -C $opc_path/kafka -zxf $dependencies_path/kafka_2.12-2.3.0.tgz
echo "Extracting spark..."
tar -C $opc_path/spark -zxf $dependencies_path/spark-2.2.1-bin-hadoop2.7.tgz
echo "Extracting osa..."
unzip -q $dependencies_path/V978767-01.zip -d $opc_path/osa