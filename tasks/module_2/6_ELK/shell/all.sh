# == Elasticksearch
yum install -y java-1.8.0-openjdk
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
echo "[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1" > /etc/yum.repos.d/elk.repo

yum install -y elasticsearch
systemctl daemon-reload

# == Only master
sed -i "s/\#node\.name\: node\-1/node\.name\: master1/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/\#network\.host\: 192\.168\.0\.1/network\.host\: \[\"localhost\"\,\"192\.168\.11\.250\"\]/" /etc/elasticsearch/elasticsearch.yml

systemctl enable --now elasticsearch

# == Only data
sed -i "s/\#node\.name\: node\-1/node\.name\: data1\nnode\.master\: false/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/\#network\.host\: 192\.168\.0\.1/network\.host\: \[\"localhost\"\,\"192\.168\.11\.251\"\]/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/\#discovery\.zen\.ping\.unicast\.hosts\: \[\"host1\"\, \"host2\"\]/discovery\.zen\.ping\.unicast\.hosts\: \[\"192\.168\.11\.250\"\]/" /etc/elasticsearch/elasticsearch.yml


# ===== Logstash

yum install -y logstash
mkdir /var/log/apache2/
wget https://github.com/linuxacademy/content-elastic-log-samples/raw/master/apache.conf -O /etc/logstash/conf.d/apache.conf
wget https://github.com/linuxacademy/content-elastic-log-samples/raw/master/access.log -O /var/log/apache2/access.log

systemctl enable --now logststash

#====
echo "input {
  beats {
    port => 5044
  }
}" > /etc/logstash/conf.d/input.conf
echo "output {
  elasticsearch {
    hosts => "localhost:9200"
    index => "nginx-%{+YYYY.MM.dd}"
  }
  #stdout { codec => rubydebug }
}" > /etc/logstash/conf.d/output.conf

echo "filter {
 if [type] == "nginx_access" {
    grok {
        match => { "message" => "%{IPORHOST:remote_ip} - %{DATA:user} \[%{HTTPDATE:access_time}\] \"%{WORD:http_method} %{DATA:url} HTTP/%{NUMBER:http_version}\" %{NUMBER:response_code} %{NUMBER:body_sent_bytes} \"%{DATA:referrer}\" \"%{DATA:agent}\"" }
    }
  }
  date {
        match => [ "timestamp" , "dd/MMM/YYYY:HH:mm:ss Z" ]
  }
  geoip {
         source => "remote_ip"
         target => "geoip"
         add_tag => [ "nginx-geoip" ]
  }
}" > /etc/logstash/conf.d/filter.conf
#===


# ===== beat
yum install -y filebeat



sed -i "s/output\.elasticsearch\:/\#output\.elasticsearch\:/" /etc/filebeat/filebeat.yml
sed -i "s/hosts\: \[\"localhost\:9200\"\]/\#hosts\: \[\"localhost\:9200\"\]/" /etc/filebeat/filebeat.yml  
  
sed -i "s/\#output\.logstash\:/output\.logstash\:/" /etc/filebeat/filebeat.yml
sed -i "s/\#hosts\: \[\"localhost\:5044\"\]/hosts\: \[\"localhost\:5044\"\]/"  /etc/filebeat/filebeat.yml


filebeat modules enable apache2

systemctl enable --now filebeat


# ===== Kibana
yum install -y kibana

sed -i "s/\#server\.host\: \"localhost\"/server\.host\: \"192\.168\.11\.250\"/" /etc/kibana/kibana.yml

systemctl enable --now kibana


ssh vagrant@192.168.11.250 -L 5601:localhost:5601