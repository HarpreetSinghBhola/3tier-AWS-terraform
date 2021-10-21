#!/bin/bash
cd $(dirname $0)
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt-get update -y
sudo apt-get install openjdk-11-jdk apt-transport-https wget nginx -y
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update -y
sudo apt-get install elasticsearch=7.15.1 -y
chmod +x /tmp/generateElaticsearchProperties.sh
sudo sh generateElaticsearchProperties.sh
sudo systemctl daemon-reload
sudo systemctl start elasticsearch.service
sudo systemctl enable elasticsearch

sleep 5

sudo apt-get install logstash -y
sudo mv 30-output.conf /etc/logstash/conf.d/30-output.conf
sudo mv 12-json.conf /etc/logstash/conf.d/12-json.conf
sudo mv 02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf

sudo systemctl start logstash
sudo systemctl enable logstash

sleep 5

sudo apt-get install kibana -y
chmod +x /tmp/generateKibanaProperties.sh
sudo sh generateKibanaProperties.sh

sudo systemctl start kibana
sudo systemctl enable kibana

sleep 5

sudo systemctl restart kibana
