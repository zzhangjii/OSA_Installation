#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)

# Stop OSA
echo "Stopping OSA..."
$opc_path/osa/OSA-18.1.0.0.1/osa-base/bin/stop-osa.sh

# Stop Spark slave
read -p "Get the Spark Master route from localhost:8080 on your VM's browser and enter it here (after spark://): "  spark_master_url
echo "Stopping Spark slave..."
$opc_path/spark/spark-2.2.1-bin-hadoop2.7/sbin/stop-slave.sh $spark_master_url

# Stop Spark master
echo "Stopping Spark master..."
$opc_path/spark/spark-2.2.1-bin-hadoop2.7/sbin/stop-master.sh

# Stop Kafka server
echo "Stopping Kafka server..."
$opc_path/kafka/kafka_2.12-2.3.0/bin/kafka-server-stop.sh

# Stop Zookeeper server
echo "Stopping Zookeeper server..."
$opc_path/kafka/kafka_2.12-2.3.0/bin/zookeeper-server-stop.sh

echo "Shutdown complete. Close the VNC connection from your local machine to fully disconnect:\nKill -9 <process_ID>"