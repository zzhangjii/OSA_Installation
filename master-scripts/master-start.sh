#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)
config_path=$PWD/../config.txt

if grep -q "SPARK_MASTER" $environment_path;
then
    :
else
    sed -i -e "\$aSPARK_MASTER=" $config_path
fi

source $config_path

# Start Zookeeper server
echo "Starting Zookeeper server..."
$opc_path/kafka/kafka_2.12-2.3.0/bin/zookeeper-server-start.sh -daemon $opc_path/kafka/kafka_2.12-2.3.0/config/zookeeper.properties

# Start Kafka server
echo "Starting Kafka server..."
$opc_path/kafka/kafka_2.12-2.3.0/bin/kafka-server-start.sh -daemon $opc_path/kafka/kafka_2.12-2.3.0/config/server.properties

# Start Spark master
echo "Starting Spark master..."
$opc_path/spark/spark-2.2.1-bin-hadoop2.7/sbin/start-master.sh

# Check or set the Spark master route
if [ -z "$SPARK_MASTER" ]
then
    read -p "Get the Spark Master route from localhost:8080 on your VM's browser and enter it here (after spark://): "  $SPARK_MASTER
    sed -i "/SPARK_MASTER/c\SPARK_MASTER=\"$SPARK_MASTER\"" $config_path
else
    echo "Verify the Spark Master route below (found at localhost:8080 on your VM's browser):"
    echo $SPARK_MASTER
    read -p "Is this route correct? (y/n): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
    then
        :
    else
        read -p "Get the Spark Master route from localhost:8080 on your VM's browser and enter it here (after spark://): "  $SPARK_MASTER
        sed -i "/SPARK_MASTER/c\SPARK_MASTER=\"$SPARK_MASTER\"" $config_path
    fi
fi

# Start Spark slave
echo "Starting Spark slave..."
$opc_path/spark/spark-2.2.1-bin-hadoop2.7/sbin/start-slave.sh $SPARK_MASTER

# Start OSA normally
echo "Starting OSA..."
$opc_path/osa/OSA-18.1.0.0.1/osa-base/bin/start-osa.sh

echo "OSA is running and available at localhost:9080/osa"