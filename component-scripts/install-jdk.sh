#!/bin/bash
# Oracle Stream Analytics Installation Scripts for Oracle Linux 7.6
# Created by Paul Chyz on 7/19/2019

#opc_path=($PWD)
opc_path=(/home/opc)
java_home=($opc_path/java/jdk1.8.0_131)

# Perform JDK install actions
sudo update-alternatives --install "/usr/bin/java" "java" $java_home/bin/java 0
sudo update-alternatives --install "/usr/bin/javac" "javac" $java_home/bin/javac 0
sudo update-alternatives --set java $java_home/bin/java
sudo update-alternatives --set javac $java_home/bin/javac