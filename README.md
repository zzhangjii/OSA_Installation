# OSA Installation
This document provides step by step instructions to install Oracle Stream Analytics (OSA) on an Oracle Linux VM.  All of these steps except for VNC viewer should be performed on the Oracle Linux Virtual Machine.

These steps will cover:
* File structure
* Installing Java Developer Kit
* Installing Apache Spark
* Installing and configuring OSA
* Starting and stopping OSA
* Setting up VNC Server
* Accessing OSA with VNC Viewer
* References

## Prerequisites
* Virtual Machine running Oracle Linux 7.6 with SSH access.
  * Provision a virtual machine with Oracle Linux 7.6 and set up SSH keys for remote access. These instructions are based on running the VM on an Oracle Cloud Infrastructure Compute Instance.
* Oracle Database 19.1 Multitenant
  * Provision an Oracle Database 19.1 Multitenant and record the following attributes: DB public IP address, DB port number, service name, root username, and root password.
* Kafka
* Zookeeper
* Oracle Golden Gate Big Data

## File Structure
In the /home/opc directory of the Oracle Linux VM Create these three directories:
1. java
   ```
   mkdir java
   ```
2. spark
   ```
   mkdir spark
   ```
3. osa
   ```
   mkdir osa
   ```

## Installing Java Developer Kit
1. Download the Java Development Kit version 8, update 131 (jdk-8u131-linux-x64.tar.gz) from [this link](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html).
2. Copy the downloaded tar file to the java folder on the Linux VM:
   ```
   scp -i <private_key_path> jdk-8u131-linux-x64.tar.gz opc@<vm_ip_address>:/home/opc/java/jdk-8u131-linux-x64.tar.gz
   ```
3. Extract the files from the tar file to the java directory:
   ```
   tar zxvf jre-8u131-linux-x64.tar.gz
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

## Installing Apache Spark
1. Download Spark 2.2.1 for Hadoop 2.7 (spark-2.2.1-bin-hadoop2.7.tgz) from [this link](https://archive.apache.org/dist/spark/spark-2.2.1/).
2. Copy the downloaded tar file to the spark folder on the Linux VM:
   ```
   scp -i <private_key_path> spark-2.2.1-bin-hadoop2.7.tgz opc@<vm_ip_address>:/home/opc/spark/spark-2.2.1-bin-hadoop2.7.tgz
   ```
3. Extract the files from the tar file to the spark directory:
   ```
   tar zxvf spark-2.2.1-bin-hadoop2.7.tgz
   ```
4. The rest of the Spark configuration will be done in OSA configuration files, so move on to 'Installing and Configuring OSA.'

## Installing and configuring OSA
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
9. Navigate to the osa/OSA-18.1.0.0.1/osa-base/bin directory:
   ```
   cd OSA-18.1.0.0.1/osa-base/bin
   ```
10. Start OSA with the initialization steps.  The first time OSA is started, the script will create a default admin user for OSA called osaadmin, and it will create metadata tables in the designated database.  The initialization will provide a prompt to set the password for the default OSA user.  After this, OSA will start running, where it will be accessible via this address: <vm_public_ip_address>:9080/osa
   ```
   ./start-osa.sh dbroot=<DB_root_user> dbroot_password=<DB_root_password>
   ```

## Starting and stopping OSA
After the initial installation, start and stop OSA using these steps.
1. Navigate to the osa/OSA-18.1.0.0.1/osa-base/bin directory:
   ```
   cd OSA-18.1.0.0.1/osa-base/bin
   ```
2. Start OSA:
   ```
   ./start-osa.sh
   ```
3. Stop OSA:
   ```
   ./stop-osa.sh
   ```

## Setting up VNC Server
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
4. Open the config file for editing and replace all <USER> values with the Oracle Linux VM’s username:
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

## Accessing OSA with VNC Viewer
1. Install VNC Viewer on the local machine from [this link](https://www.realvnc.com/en/connect/download/viewer/).
2. Connect to the VNC Server on the Oracle Linux VM (still using port 5901 as an example):
   ```
   ssh -i ~/.ssh/osaVM.txt -L 5901:localhost:5901 opc@<vm_public_ip_address> -N &
   ```
3. Open VNC Viewer, double-click on the correct connection, and enter the password that was previously set to access the desktop environment.
4. To disconnect, run the command below.  The process ID can be found as output from the command in step 2:
   ```
   Kill -9 <process_ID>
   ```
5. Verify the disconnection by checking the machine's list of ssh connections:
   ```
   ps aux | grep ssh
   ```

## References
* [Official OSA Installation Documentation](https://docs.oracle.com/en/middleware/fusion-middleware/osa/18.1/install-stream-analytics/how-install-oracle-stream-analytics.html#GUID-13BC895D-6AD1-4398-98E2-B5BE5B14D26B)
* [Initializing Metadata Store](https://docs.oracle.com/en/middleware/fusion-middleware/osa/18.1/install-stream-analytics/initializing-metadata-store.html)
* [Configuring a VNC Server](https://docs.oracle.com/cd/E52668_01/E54669/html/ol7-vnc-config.html)