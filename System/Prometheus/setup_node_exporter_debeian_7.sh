#!/bin/bash

cd /opt
wget https://github.com/nintech-sudo/studydevsysops/raw/main/System/Prometheus/node_exporter-1.2.2.linux-amd64.tar.gz
tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz
mv node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin/
groupadd -f node_exporter
useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter
touch /etc/init.d/node_exporter


#Setup Node Exporter Service
cat << EOF > /etc/init.d/node_exporter
#!/bin/sh
### BEGIN INIT INFO
# Provides:          node_exporter
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Node Exporter
# Description:       Prometheus exporter for machine metrics
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/bin/node_exporter
USER=node_exporter
GROUP=node_exporter

test -x $DAEMON || exit 0

set -e

case "$1" in
  start)
        echo -n "Starting node_exporter: "
        start-stop-daemon --start --background --chuid "$USER:$GROUP" --exec $DAEMON
        echo "done."
        ;;
  stop)
        echo -n "Stopping node_exporter: "
        start-stop-daemon --stop --signal TERM --quiet --retry 5 --pidfile /var/run/node_exporter.pid --name node_exporter
        echo "done."
        ;;
  restart)
        echo "Restarting node_exporter: "
        $0 stop
        sleep 1
        $0 start
        ;;
  *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart}" >&2
        exit 1
        ;;
esac

exit 0
EOF

chmod +x /etc/init.d/node_exporter
service node_exporter start
echo "Please check firewall and open port 9100"
echo "http://$(hostname -I):9100/metrics"