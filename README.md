# GGBG-Kafka-OSA-ElasticSearch Pipeline setup
This document provides instructions for using shell scripts to install and set up a data pipeline from GoldenGate Bigdata to Oracle Stream Analytics (OSA) and open-source visualization tool (Elastic Search) on Oracle Cloud.

### Prerequisites
* Virtual Machine running Oracle Linux 7.6 with SSH access
* Oracle Database 19.1 Multitenant
  * Take note of the following attributes: DB public IP address, DB port number, service name, root username, and root password

## Shell Script Installation
Follow these steps to install OSA on Oracle Linux 7.6 using the included shell scripts. Before beginning, ensure that you have satisfied the prerequisites listed above.

### Preparation
1. Connect to the Oracle Linux VM via SSH:
   ```
   ssh -i <private_key_path> opc@<vm_ip_address>
   ```
2. Install git on the Oracle Linux VM:
   ```
   sudo yum install git
   ```
3. Clone this repository to the opc directory of the Oracle Linux VM:
   ```
   git clone https://github.com/paulchyz/OSA_Installation.git
   ```
4. On your local machine, download the Java Developer Kit version 8, update 131 (jdk-8u131-linux-x64.tar.gz) from [this link](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html) and copy it to the `OSA_Installation/dependencies` directory:
   ```
   scp -i <private_key_path> jdk-8u131-linux-x64.tar.gz opc@<vm_ip_address>:/home/opc/OSA_Installation/dependencies/jdk-8u131-linux-x64.tar.gz
   ```
5. On your local machine, get the mirror link for the Kafka 2.3.0 binary for Scala 2.12 from [this link](https://www.apache.org/dyn/closer.cgi?path=/kafka/2.3.0/kafka_2.12-2.3.0.tgz) and run the `wget` command from the `OSA_Installation/dependencies` directory of the Oracle Linux VM to download Kafka:
   ```
   cd dependencies
   ```
   ```
   wget <kafka_binary_mirror_link>
   ```
6. On your local machine, download Spark 2.2.1 for Hadoop 2.7 (spark-2.2.1-bin-hadoop2.7.tgz) from [this link](https://archive.apache.org/dist/spark/spark-2.2.1/) and copy it to the `OSA_Installation/dependencies` directory:
   ```
   scp -i <private_key_path> spark-2.2.1-bin-hadoop2.7.tgz opc@<vm_ip_address>:/home/opc/OSA_Installation/dependencies/spark-2.2.1-bin-hadoop2.7.tgz
   ```
7. On your local machine, download Oracle Stream Analytics 18.1.0.0.1 (V978767-01.zip) from [this link](https://www.oracle.com/middleware/technologies/stream-analytics/downloads.html#) and copy it to the `OSA_Installation/dependencies` directory:
   ```
   scp -i <private_key_path> V978767-01.zip opc@<vm_ip_address>:/home/opc/OSA_Installation/dependencies/V978767-01.zip
   ```
8. There is a config file in the `OSA_Installation` directory with the required parameters listed but not defined. The installation scripts will prompt for user input as needed to set these values, but this file can be edited manually or shared for pre-configured OSA installations on other systems.

### Installation
1. Connect to the Oracle Linux VM via SSH:
   ```
   ssh -i <private_key_path> opc@<vm_ip_address>
   ```
2. Navigate to the "master-scripts" directory:
   ```
   cd /home/opc/OSA_Installation/master-scripts
   ```
3. Run the master install script and follow the prompts throughout the process:
   ```
   ./master-install.sh
   ```
4. Close the SSH connection:
   ```
   exit
   ```
5. On your local machine, [set up VNC Viewer](#setting-up-vnc-viewer) with a connection to the VM.
6. Run the master initialize script and follow the prompts throughout the process:
   ```
   ./master-initialize.sh
   ```
7. Run the master start script and follow the prompts throughout the process:
   ```
   ./master-start.sh
   ```
8. OSA is now accessible on the VM's browser via `localhost:9080/osa` or from another machine's browser via `<vm_public_ip_address>:9080/osa` if the networking has been set up to allow outside traffic.
9. Access OSA's browser interface, and complete the [post-installation configuration](#post-installation-configuration)
10. To stop OSA, run the master stop script and follow the prompts throughout the process:
    ```
    ./master-stop.sh
    ```

## Manual Installation
All of these steps except for setting up VNC Viewer should be performed on the Oracle Linux Virtual Machine. Before beginning, ensure that you have satisfied the prerequisites listed above.

These steps will cover:
* [File structure](#file-structure)
* [Installing Java Developer Kit](#installing-java-developer-kit)
* [Installing Apache Kafka](#installing-apache-kafka)
* [Installing Apache Spark](#installing-apache-spark)
* [Installing and configuring OSA](#installing-and-configuring-osa)
* [Setting up VNC Server](#setting-up-vnc-server)
* [Setting up VNC Viewer](#setting-up-vnc-viewer)
* [Starting the OSA environment](#starting-the-osa-environment)
* [Stopping the OSA environment](#stopping-the-osa-environment)
* [Post-installation configuration](#post-installation-configuration)
* [References](#references)

### File Structure
In the /home/opc directory of the Oracle Linux VM Create these three directories:
1. java
   ```
   mkdir java
   ```
2. kafka
   ```
   mkdir kafka
   ```
3. spark
   ```
   mkdir spark
   ```
4. osa
   ```
   mkdir osa
   ```

### Installing Java Developer Kit
1. Download the Java Development Kit version 8, update 131 (jdk-8u131-linux-x64.tar.gz) from [this link](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html).
2. Copy the downloaded tar file to the java folder on the Linux VM:
   ```
   scp -i <private_key_path> jdk-8u131-linux-x64.tar.gz opc@<vm_ip_address>:/home/opc/java/jdk-8u131-linux-x64.tar.gz
   ```
3. Extract the files from the tar file to the java directory:
   ```
   tar zxvf jdk-8u131-linux-x64.tar.gz
   ```
4. Edit the environment variables to reflect the path to java, as shown in the modified file sample below:
   ```
   sudo vim /etc/environment
   ```
   Modified file:
   ```
   PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/opc/java/jdk1.8.0_131/bin":$PATH
   JAVA_HOME="/home/opc/java/jdk1.8.0_131"
   ```
5. Perform install actions for Java:
   ```
   sudo update-alternatives --install "/usr/bin/java" "java" "/home/opc/java/jdk1.8.0_131/bin/java" 0
   ```
   ```
   sudo update-alternatives --install "/usr/bin/javac" "javac" "/home/opc/java/jdk1.8.0_131/bin/javac" 0
   ```
   ```
   sudo update-alternatives --set java /home/opc/java/jdk1.8.0_131/bin/java
   ```
   ```
   sudo update-alternatives --set javac /home/opc/java/jdk1.8.0_131/bin/javac
   ```
6. Close the SSH connection and reconnect, then verify the Java installation:
   ```
   java -version
   ```

### Installing Apache Kafka
1. Navigate to the kafka directory:
   ```
   cd kafka
   ```
2. Download the Kafka 2.3.0 binary for Scala 2.12 using [this link](https://kafka.apache.org/downloads) and the following command:
   ```
   wget <kafka_binary_mirror_link>
   ```
3. Extract the files from the tar file to the kafka directory:
   ```
   tar zxvf kafka_2.12-2.3.0.tg
   ```

### Installing Apache Spark
1. Download Spark 2.2.1 for Hadoop 2.7 (spark-2.2.1-bin-hadoop2.7.tgz) from [this link](https://archive.apache.org/dist/spark/spark-2.2.1/).
2. Copy the downloaded tar file to the spark folder on the Linux VM:
   ```
   scp -i <private_key_path> spark-2.2.1-bin-hadoop2.7.tgz opc@<vm_ip_address>:/home/opc/spark/spark-2.2.1-bin-hadoop2.7.tgz
   ```
3. Extract the files from the tar file to the spark directory:
   ```
   tar zxvf spark-2.2.1-bin-hadoop2.7.tgz
   ```
4. Nagivate to the spark-2.2.1-bin-hadoop2.7/conf directory:
   ```
   cd spark-2.2.1-bin-hadoop2.7/conf
   ```
5. Copy the spark-env.sh.template file to spark-env.sh in the same directory:
   ```
   cp spark-env.sh.template spark-env.sh
   ```
6. Open spark-env.sh for editing:
   ```
   vim spark-env.sh
   ```
7. Add the following lines below their corresponding properties in spark-env.sh:
   ```
   export SPARK_WORKER_CORES=12
   ```
   ```
   export SPARK_WORKER_MEMORY=10g
   ```
8. The rest of the Spark configuration will be done in OSA configuration files and in later steps, so move on to 'Installing and Configuring OSA.'

### Installing and Configuring OSA
1. Download Oracle Stream Analytics 18.1.0.0.1 (V978767-01.zip) from [this link](https://www.oracle.com/middleware/technologies/stream-analytics/downloads.html#).
2. Copy the downloaded tar file to the osa folder on the Linux VM:
   ```
   scp -i <private_key_path> V978767-01.zip opc@<vm_ip_address>:/home/opc/osa/ V978767-01.zip
   ```
3. Unzip the OSA file to the osa directory:
   ```
   unzip V978767-01.zip
   ```
4. To configure OSA environment variables, set the current directory to osa, then open osa-env.sh for editing:
   ```
   vim OSA-18.1.0.0.1/osa-base/etc/osa-env.sh
   ```
5. Insert the paths for SPARK_HOME and JAVA_HOME below the lines for SUPPORTED_SPARK_VERSION and SUPPORTED_JAVA_VERSION:
   ```
   SPARK_HOME="/home/opc/spark/spark-2.2.1-bin-hadoop2.7"
   JAVA_HOME="/home/opc/java/jdk1.8.0_131"
   ```
6. To configure the database variables, set the current directory to osa, then open jetty-osa-datasource.xml for editing:
   ```
   vim OSA-18.1.0.0.1/osa-base/etc/jetty-osa-datasource.xml
   ```
7. Uncomment the Oracle Databse configuration section, leaving the MySQL configuration commented out.
8. Replace the URL, User, and Password details in square brackets as shown below:
   ```
   <New id="osads" class="org.eclipse.jetty.plus.jndi.Resource">
       <Arg>
        <Ref refid="wac"/>
       </Arg>
       <Arg>jdbc/OSADataSource</Arg>
       <Arg>
           <New class="oracle.jdbc.pool.OracleDataSource">
               <Set name="URL">jdbc:oracle:thin:@[DB_IP_ADDRESS]:[DB_PORT]/[SERVICE_NAME]</Set>
               <Set name="User">[DB_USERNAME]</Set>
               <Set name="Password">[DB_PASSWORD]</Set>
               <Set name="connectionCachingEnabled">true</Set>
               <Set name="connectionCacheProperties">
                   <New class="java.util.Properties">
                       <Call name="setProperty"><Arg>MinLimit</Arg><Arg>1</Arg></Call>
                       <Call name="setProperty"><Arg>MaxLimit</Arg><Arg>15</Arg></Call>
                       <Call name="setProperty"><Arg>InitialLimit</Arg><Arg>1</Arg></Call>
                   </New>
               </Set>
           </New>
       </Arg>
   </New>
   ```

### Setting up VNC Server
These steps should be performed on the Oracle Linux VM.
1. Begin installation process:
   ```
   sudo yum install tigervnc-server
   ```
2. Set password by entering this command and following the prompts:
   ```
   vncpasswd
   ```
3. Copy template file (display number set to 1 for this example):
   ```
   sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@\:1.service
   ```
4. Open the config file for editing and replace all `<USER>` values with the Oracle Linux VM’s username:
   ```
   sudo vim /etc/systemd/system/vncserver@\:1.service
   ```
5. Reload, start, and enable VNC Server:
   ```
   sudo systemctl daemon-reload
   ```
   ```
   sudo systemctl start vncserver@\:1.service
   ```
   ```
   sudo systemctl enable vncserver@\:1.service
   ```
6. Configure firewall (this example adds port 5901):
   ```
   sudo firewall-cmd --zone=public --add-service=vnc-server
   ```
   ```
   sudo firewall-cmd --zone=public --add-service=vnc-server –permanent
   ```
   ```
   sudo firewall-cmd --zone=public --add-port=5901/tcp
   ```
   ```
   sudo firewall-cmd --zone=public --add-port=5901/tcp –permanent
   ```
7. Install desktop environment:
   ```
   sudo yum groupinstall "server with gui"
   ```
   ```
   sudo systemctl set-default graphical.target
   ```
   ```
   sudo systemctl restart vncserver@\:1.service
   ```

### Setting up VNC Viewer
1. Install VNC Viewer on the local machine from [this link](https://www.realvnc.com/en/connect/download/viewer/).
2. Connect to the VNC Server on the Oracle Linux VM (still using port 5901 as an example):
   ```
   ssh -i <private_key_path> -L 5901:localhost:5901 opc@<vm_public_ip_address> -N &
   ```
3. Open VNC Viewer, click on "File," then click "New Connection."
4. In the VNC Server parameter, enter localhost:<vnc_server_port> and give the connection a name. 
5. On the next page, enter the password that was previously set to access the desktop environment.
6. To disconnect, run the command below.  The process ID can be found as output from the command in step 2:
   ```
   Kill -9 <process_ID>
   ```
7. Verify the disconnection by checking the machine's list of ssh connections:
   ```
   ps aux | grep ssh
   ```

### Starting the OSA Environment
These actions should be performed from the /home/opc directory.
1. Connect to the Oracel Linux VM using VNC viewer (change port 5901 if needed):
   ```
   ssh -i <private_key_path> -L 5901:localhost:5901 opc@<vm_public_ip_address> -N &
   ```
2. Open terminal, and navigate to the /home/opc directory:
   ```
   cd /home/opc
   ```
1. Start the Zookeeper server:
   ```
   kafka/kafka_2.12-2.3.0/bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
   ```
2. Start the Kafka server:
   ```
   kafka/kafka_2.12-2.3.0/bin/kafka-server-start.sh config/server.properties
   ```
3. Start the Spark Master:
   ```
   spark/spark-2.2.1-bin-hadoop2.7/sbin/start-master.sh
   ```
4. On the VM's browser, navigate to localhost:8080 and copy the Spark Master route that follows "spark://"
5. Start the Spark Slave passing the Spark Master route as a parameter:
   ```
   spark/spark-2.2.1-bin-hadoop2.7/sbin/start-slave.sh <spark_master_url>
   ```
6. If starting OSA for the first time, start OSA with initialization steps.  The script will create a default admin user for OSA called osaadmin, and it will create metadata tables in the designated database.  The initialization will provide a prompt to set the password for the default OSA user:
   ```
   osa/OSA-18.1.0.0.1/osa-base/bin/start-osa.sh dbroot=<DB_root_user> dbroot_password=<DB_root_password>
   ```
7. If OSA has already been started with initialization steps, start OSA normally:
   ```
   osa/OSA-18.1.0.0.1/osa-base/bin/start-osa.sh
   ```
8. After starting OSA, the user interface will be accessible on the VM's browser via `localhost:9080/osa` or from another machine's browser via `<vm_public_ip_address>:9080/osa` if the networking has been set up to allow outside traffic.

### Stopping the OSA Environment
1. Stop OSA:
   ```
   osa/OSA-18.1.0.0.1/osa-base/bin/stop-osa.sh
   ```
2. Stop the Spark Slave:
   ```
   spark/spark-2.2.1-bin-hadoop2.7/sbin/stop-slave.sh <spark_master_url>
   ```
3. Stop the Spark Master:
   ```
   spark/spark-2.2.1-bin-hadoop2.7/sbin/stop-master.sh
   ```
4. Stop the Kafka server:
   ```
   kafka/kafka_2.12-2.3.0/bin/kafka-server-stop.sh
   ```
5. Stop the Zookeeper server:
   ```
   kafka/kafka_2.12-2.3.0/bin/zookeeper-server-stop.sh
   ```
6. Close the VNC Viewer window.
7. Close the VNC connection in the local machine's terminal, using the process ID given as output from the initial VNC connection command:
   ```
   Kill -9 <process_ID>
   ```
8. Verify the disconnection by checking the machine's list of ssh connections:
   ```
   ps aux | grep ssh
   ```

### Post-Installation Configuration
After completing the OSA startup process and accessing OSA via the web browser on VNC Viewer, there are some configuration parameters that need to be set:
   * Click on the user icon in the top right corner of the screen and select system settings
     ![image](https://user-images.githubusercontent.com/42782692/61556929-c2c26400-aa17-11e9-8e70-0b66967c7a96.png)
   * Set the Kafka ZooKeeper Connection to "localhost:2181"
   * Set the Runtime Server to "Spark Standalone"
   * Enter the Spark Master route (found at localhost:8080 on the VM) into the Spark REST URL parameter in OSA's system settings.
   * Select the NFS storage option, and set the path to "tmp/spark-deploy"
   * The resources allocated to OSA can be configured in the "Pipelines" tab of the settings window.
   * Click save

### References
* [Official OSA Installation Documentation](https://docs.oracle.com/en/middleware/fusion-middleware/osa/18.1/install-stream-analytics/how-install-oracle-stream-analytics.html#GUID-13BC895D-6AD1-4398-98E2-B5BE5B14D26B)
* [Initializing Metadata Store](https://docs.oracle.com/en/middleware/fusion-middleware/osa/18.1/install-stream-analytics/initializing-metadata-store.html)
* [Configuring a VNC Server](https://docs.oracle.com/cd/E52668_01/E54669/html/ol7-vnc-config.html)
