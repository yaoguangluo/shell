#!bin/bash
uname -r 3.10.0-327.el7.x86_64
sudo yum update
yum install net-tools -y
yum install wget -y
sudo yum remove docker docker-common docker-selinux docker-engine
wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
sudo sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo yum makecache fast
sudo yum install docker-ce
chmod 777 /etc
mkdir /etc/docker
#//add//
touch /etc/docker/daemon.json
echo "{\"registry-mirrors\": [\"http://4c7d9402.m.daocloud.io\"]}" >> /etc/docker/daemon.json
more /etc/docker/daemon.json 
# {"registry-mirrors": ["http://4c7d9402.m.daocloud.io"]}
systemctl enable docker
service docker start 
docker version 
sudo mkdir -p /opt/mysql-ci/data
#//evironment
docker pull jenkins:latest
docker pull gitlab/gitlab-ce:latest
docker pull sonarqube:latest
sudo docker pull sameersbn/mysql:latest
docker pull postgres
#//postgre
docker run --name db -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres
#//mysql sonar选了 postgre 就不要用mysql 各有各好处
docker run --name mysql-sonar -e MYSQL_ROOT_PASSWORD=mysql -e MYSQL_DATABASE=sonar -e MYSQL_USER=sonar -e MYSQL_PASSWORD=sonar -v /path/to/local/mysql/dir:/var/lib/mysql -p 33066:3306 -d mysql:latest
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092  --link=mysql-sonar:mysql   -e SONARQUBE_JDBC_USERNAME=sonar     -e SONARQUBE_JDBC_PASSWORD=sonar    -e SONARQUBE_JDBC_URL="jdbc:mysql://mysql:3306/sonar?
useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false" sonarqube
#//mysqlroot
docker run --name=mysql-ci -d -e 'DB_NAME=gitlab_ci_production' -e 'DB_USER=gitlab_ci' -e 'DB_PASS=XXXXX' -v /opt/mysql-ci/data:/var/lib/mysql  sameersbn/mysql:latest
#//jenkins
docker run -it --name jenkinsci0001 -d -v $HOME/jenkins:/var/  -p 8888:8080 -p 55000:50000 -p 45000:45000 jenkins:latest
#//sona
docker run --name sq -d --link db  -e SONARQUBE_JDBC_URL=jdbc:postgresql://db:5432/sonar -p 9000:9000 -d sonarqube:latest
#//gitlab
sudo docker run -d --detach --hostname 192.168.244.132 --publish 443:443 --publish 80:80 --publish 222:22 --name gitlab --restart always --volume /srv/gitlab/config:/etc/gitlab --
volume/srv/gitlab/logs:/var/log/gitlab --volume /srv/gitlab/data:/var/opt/gitlab gitlab/gitlab-ce:latest
docker run --name='gitlab-ce' -d -p 10022:22 -p 80:80 --restart always --volume /opt/gitlab/config:/etc/gitlab --volume /opt/gitlab/logs:/var/log/gitlab --volume /opt/gitlab/data:/var/opt/gitlab/ gitlab/gitlab-ce
docker pull sameersbn/gitlab-ci
sudo mkdir -p /opt/gitlab-ci/data
#//redis
docker pull sameersbn/redis
docker run -p 6379:6379 -v $PWD/data:/data  -d sameersbn/redis redis-server --appendonly yes
docker run -d --name='gitlab-ci' -it --rm  --link mysql-ci:mysql  --link distracted_cray:redis  --link gitlab:gitlab  -e 'SMTP_ENABLED=true'  -e 'SMTP_USER=' -e 'SMTP_HOST=172.17.42.1'  -e 'SMTP_PORT=25'   -e 'SMTP_STARTTLS=false'  -e 'SMTP_OPENSSL_VERIFY_MODE=none'  -e 'SMTP_AUTHENTICATION=:plain'  -e 'GITLAB_CI_PORT=8080'  -e 'GITLAB_CI_HOST=workbench.dachary.org'  -p 8080:8080  -v /var/run/docker.sock:/run/docker.sock -v /opt/gitlab-ci/data:/home/gitlab_ci/data  -v $(which docker):/bin/docker  sameersbn/gitlab-ci
sudo docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock    gitlab/gitlab-runner:latest