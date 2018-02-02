#!/bin/bash
#掳虏装gcc
yum install gcc-c++
#陆脫詹脦媒is压脣掳眉路戮露
src=/usr/local/redis/redis-4.0.7.tar.gz
#陆脫詹脦媒is掳虏装戮酶戮露
target=/usr/local/redis
echo $src
unzipParentDir=${src%/*}
temp=${src%t*}
#陆芒脣潞贸驴录
unzipDir=${temp%.*}
echo "directory :"$unzipParentDir
echo "file path :"$unzipDir
#unzip tar file to current directory
#陆芒脣
tar -xzvf $src -C $unzipParentDir
#陆酶压潞贸驴录
cd $unzipDir
echo `pwd`
#卤脿
make
#掳虏装
make PREFIX=$target install
#赂麓脰redis脜脰脦录镁
cp -f redis.conf $target"/"bin
#陆酶装目录脧碌脛in目录
cd $target"/bin"
#脝露炉redis
./redis-server redis.conf
#鹿乇辗;冒
systemctl stop firewalld.service
