#!/bin/sh

echo "Starting rsyslog service"
# Make sure rsyslog service is running
service rsyslog start

# Touch the log file so we can tail on it
touch /var/log/haproxy.log

# Throw the log to output
tail -f /var/log/haproxy.log &

# Staring haproxy service
echo "Starting haproxy service"
start-stop-daemon --quiet --oknodo --start --pidfile "$PIDFILE" --exec /usr/local/sbin/haproxy -- -f /etc/haproxy/haproxy.cfg -D -p "$PIDFILE"

# Start consul template
echo "Starting consul template service"
exec consul-template -config=/tmp/haproxy.hcl -consul-addr=$CONSUL_ADDR
