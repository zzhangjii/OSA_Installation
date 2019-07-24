#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)

echo "Removing directory: java"
rm -rf $opc_path/java
echo "Removing directory: kafka"
rm -rf $opc_path/kafka
echo "Removing directory: spark"
rm -rf $opc_path/spark
echo "Removing directory: osa"
rm -rf $opc_path/osa

