#!/bin/bash
MYSQL_PASSWD="123456"
yum remove  -y mysql mysql-server
yum install -y cmake     ncurses-devel 
tar xf mysql-5.6.26.tar.gz -C /usr/local/src/ 
cd /usr/local/src/mysql-5.6.26
useradd -M -s /sbin/nologin mysql 
cmake \
 -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
 -DDEFAULT_CHARSET=utf8 \
 -DDEFAULT_COLLATION=utf8_general_ci \
 -DWITH_EXTRA_CHARSETS=all \
 -DWITH_MYISAM_STORAGE_ENGINE=1\
 -DWITH_INNOBASE_STORAGE_ENGINE=1\
 -DWITH_MEMORY_STORAGE_ENGINE=1\
 -DWITH_READLINE=1\
 -DENABLED_LOCAL_INFILE=1\
 -DMYSQL_DATADIR=/usr/local/mysql/data \
 -DMYSQL-USER=mysql
make -j 4 && make install
cd && chown -R mysql:mysql /usr/local/mysql/
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf  
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
sed  -i 's%^basedir=%basedir=/usr/local/mysql%' /etc/init.d/mysqld
sed  -i 's%^datadir=%datadir=/usr/local/mysql/data%' /etc/init.d/mysqld
chkconfig mysqld on
/usr/local/mysql/scripts/mysql_install_db \
 --defaults-file=/etc/my.cnf  \
 --basedir=/usr/local/mysql/  \
 --datadir=/usr/local/mysql/data/  \
 --user=mysql
ls /usr/local/mysql/data/
ln -s /usr/local/mysql/bin/* /bin/
service mysqld start
echo "now let's begin mysql_secure_installation "
if [ ! -e /usr/bin/expect ] 
 then  yum install expect -y 
fi
echo '#!/usr/bin/expect
set timeout 60
set password [lindex $argv 0]
spawn mysql_secure_installation
expect {
"enter for none" { send "\r"; exp_continue}
"Y/n" { send "Y\r" ; exp_continue}
"password" { send "$password\r"; exp_continue}
"Cleaning up" { send "\r"}
}
interact ' > mysql_secure_installation.exp 
chmod +x mysql_secure_installation.exp
./mysql_secure_installation.exp $MYSQL_PASSWD 
