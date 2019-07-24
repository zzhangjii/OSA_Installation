#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)
osa_spark_home=($opc_path/spark/spark-2.2.1-bin-hadoop2.7)
spark_env=($opc_path/spark/spark-2.2.1-bin-hadoop2.7/conf/spark-env.sh)

# Configure Apache Spark
cp $osa_spark_home/conf/spark-env.sh.template $spark_env
sed -i "/^# - SPARK_WORKER_CORES.*/a export SPARK_WORKER_CORES=12" $spark_env
sed -i "/^# - SPARK_WORKER_MEMORY.*/a export SPARK_WORKER_MEMORY=10g" $spark_env