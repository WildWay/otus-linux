#!/usr/bin/env bash
mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

yum install -y ansible vim epel-release
yum install -y java-1.8.0-openjdk 

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
echo "
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1" > /etc/yum.repos.d/elk.repo

yum install -y elasticsearch

sed -i "s/\#node\.name\: node\-1/node\.name\: data1\nnode\.master\: false/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/\#network\.host\: 192\.168\.0\.1/network\.host\: \[\"localhost\"\,\"192\.168\.11\.251\"\]/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/\#discovery\.zen\.ping\.unicast\.hosts\: \[\"host1\"\, \"host2\"\]/discovery\.zen\.ping\.unicast\.hosts\: \[\"192\.168\.11\.250\"\]/" /etc/elasticsearch/elasticsearch.yml

echo "============================================"
echo "Имя хоста - `hostname`"
echo "IP адрес для подключения - `hostname -I | cut -d ' ' -f 2`"
echo "============================================"