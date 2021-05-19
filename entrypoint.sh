#!/bin/bash

HOST_IP_ADDR=${HOST_IP_ADDR:-}
HOST_HTTP_PORT=${HOST_HTTP_PORT:-80}

if [ -z "${HOST_IP_ADDR}" ]
then
  echo "ERROR: HOST_IP_ADDR env cannot be empty. Set this variable value with the IP address of host which run docker"
  exit 1
fi

sed -i \
    -e "/^next_server/ s/:.*$/: ${HOST_IP_ADDR}/" \
    -e "/^server/ s/:.*$/: ${HOST_IP_ADDR}/" \
    -e "/^http_port:/ s/:.*$/: ${HOST_HTTP_PORT}/" \
    /etc/cobbler/settings

cat /etc/cobbler/settings

/usr/local/bin/first-sync.sh &
echo "Running supervisord"
/usr/bin/supervisord -c /etc/supervisord.conf

