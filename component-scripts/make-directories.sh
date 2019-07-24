#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)

# Make directories for OSA installation
echo "Making directory: java"
mkdir -p $opc_path/java
echo "Making directory: kafka"
mkdir -p $opc_path/kafka
echo "Making directory: spark"
mkdir -p $opc_path/spark
echo "Making directory: osa"
mkdir -p $opc_path/osa