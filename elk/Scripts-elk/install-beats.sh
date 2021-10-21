#!/bin/bash
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.15.1-amd64.deb
sudo dpkg -i filebeat-7.15.1-amd64.deb
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.15.1-amd64.deb
sudo dpkg -i metricbeat-7.15.1-amd64.deb
sudo systemctl enable filebeat
sudo systemctl enable metricbeat