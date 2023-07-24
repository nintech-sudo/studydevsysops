#!/bin/bash

wget https://github.com/nintech-sudo/studydevsysops/raw/main/System/Prometheus/node_exporter-1.0.1.linux-amd64.tar.gz

# Create User
sudo groupadd -f node_exporter
sudo useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/node_exporter
sudo chown node_exporter:node_exporter /etc/node_exporter

# Unpack Node Exporter Binary
tar -xvf node_exporter-1.0.1.linux-amd64.tar.gz
mv node_exporter-1.0.1.linux-amd64 node_exporter-files

# Install Node Exporter
sudo cp node_exporter-files/node_exporter /usr/bin/
sudo chown node_exporter:node_exporter /usr/bin/node_exporter

#Setup Node Exporter Service
cat << EOF > /usr/lib/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Documentation=https://prometheus.io/docs/guides/node-exporter/
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter --web.listen-address=:9100

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 664 /usr/lib/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter.service
sudo systemctl status node_exporter

ip_address=$(curl -s http://vinahost.vn)
echo "Please check firewall and open port 9100"
echo "http://$ip_address:9100/metrics"