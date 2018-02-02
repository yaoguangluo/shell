#ÇÐ»»µ½rootÈ¨ÏÞ  
sudo su  
  
cenhOS yum -y install wget

#create java dir  
java_file="/usr/local/java"  
  
  
if [ ! -d "$java_file" ];  
then  
 mkdir $java_file  
fi  
  
  
cd /usr/local/java  
  
  
if [ ! -d "jdk-8u131-linux-x64.tar.gz" ];  
then  
 wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz  
fi  
  
  
if [ ! -d "jdk1.8.0_131" ];  
then  
 tar -xvf jdk-8u131-linux-x64.tar.gz  
fi  
  
  
#set environment  
export JAVA_HOME="/usr/local/java/jdk1.8.0_131"  
if ! grep "JAVA_HOME=/usr/local/java/jdk1.8.0_131" /etc/environment  
then  
    echo "JAVA_HOME=/usr/local/java/jdk1.8.0_131" | sudo tee -a /etc/environment  
    echo "export JAVA_HOME" | sudo tee -a /etc/environment  
    echo "PATH=$PATH:$JAVA_HOME/bin" | sudo tee -a /etc/environment  
    echo "export PATH" | sudo tee -a /etc/environment  
    echo "CLASSPATH=.:$JAVA_HOME/lib" | sudo tee -a /etc/environment  
    echo "export CLASSPATH" | sudo tee -a /etc/environment  
fi  
  
  
source /etc/environment  
echo "jdk is installed !"  
