#!/bin/sh

# Validate new haproxy configuration before reloading 
if haproxy -c -V -f /etc/haproxy/haproxy.cfg
then
  echo "Reloading haproxy with new configuration"
  # The unix socket is transferred between the old and new process so that no query fails
  haproxy -f /etc/haproxy/haproxy.cfg -p $PIDFILE -sf $(cat $PIDFILE) -x /var/run/haproxy/admin.sock
else
  echo "Cannot reload haproxy with bad new configuration"
fi
