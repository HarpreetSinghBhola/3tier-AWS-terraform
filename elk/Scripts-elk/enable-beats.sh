#!/bin/bash
cd $(dirname $0)
filebeat modules enable system
filebeat setup -e
systemctl restart filebeat


# Enabling metricbeat
metricbeat setup -e
service metricbeat restart

