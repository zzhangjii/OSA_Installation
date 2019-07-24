#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

opc_path=($PWD)
# opc_path=(/home/opc)
#environment_path=(/etc/environment)
environment_path=($opc_path/test)
java_home=($opc_path/java/jdk1.8.0_131)
jdk_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/opc/java/jdk1.8.0_131/bin"

# Set PATH and JAVA_HOME
if [ -s $environment_path ]
then
    # File not empty
    if grep -q "PATH" $environment_path;
    then
        # PATH found
        # Ask to append to PATH
        read -p "Are you ok with appending the environment PATH? (y/n): " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
        then
            echo "Appending PATH..."
            # Remove all " from PATH
            sed -i "/^PATH/s/\"//g" environment_path
            # Insert first " back into PATH
            sed -i "/^PATH/s/PATH=/PATH=\"/" environment_path
            # Remove $PATH from PATH
            sed -i "/^PATH/s/\$PATH//" environment_path
            # Remove last character if it's :
            sed -i "s/:$//" environment_path
            # Add new PATH variables with leading :
            sed -i "/^PATH/ s,$,:$jdk_path\":\$PATH," environment_path

        else
            $opc_path/cleanup-osa.sh -y
            exit 1
        fi
    else
        # PATH not found
        echo "Writing PATH..."
        sed -i "1 i\PATH=\"$jdk_path\":\$PATH" environment_path
    fi

    if grep -q "JAVA_HOME" $environment_path;
    then
        # JAVA_HOME found
        # Ask to change JAVA_HOME
        read -p "Are you ok with changing JAVA_HOME? (y/n): " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
        then
            echo "Changing JAVA_HOME..."
            sed -i "/JAVA_HOME/c\JAVA_HOME=\"$java_home\"" environment_path
        else
            $opc_path/cleanup-osa.sh -y
            exit 1
        fi
    else
        # JAVA_HOME not found
        echo "Writing JAVA_HOME..."
        sed -i -e "\$aJAVA_HOME=\"$java_home\"" environment_path
    fi

else
    # File empty
    echo "Writing PATH and JAVA_HOME..."
    sed -i -e "\$aPATH=\"$jdk_path\":\$PATH\nJAVA_HOME=\"$java_home\"" environment_path
    
fi