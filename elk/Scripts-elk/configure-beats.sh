elkserver=$1
sed -i 's/localhost/'$elkserver'/g' /etc/filebeat/filebeat.yml
sed -i 's/setup.kibana:/#setup.kibana:/g' /etc/filebeat/filebeat.yml
cat >> /etc/filebeat/filebeat.yml<<EOF1
setup.kibana:
  host: $elkserver:5601
EOF1


sed -i 's/localhost/'$elkserver'/g' /etc/metricbeat/metricbeat.yml
sed -i 's/setup.kibana:/#setup.kibana:/g' /etc/metricbeat/metricbeat.yml
cat >> /etc/metricbeat/metricbeat.yml<<EOF2
setup.kibana:
  host: $elkserver:5601
EOF2
