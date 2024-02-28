#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)

if [ $service -eq 1 ]
then status="ok"
else status="error"; note="service not running"
fi

logs=$(journalctl -u availightd --no-hostname -o cat | tail -5)

cat << EOF
{
  "project":"$folder",
  "id":$AVAIL_ID,
  "machine":"$MACHINE",
  "chain":"goldberg",
  "type":"node",
  "status":"$status",
  "note":"$note",
  "service":$service,
  "updated":"$(date --utc +%FT%TZ)",
  "logs": 
  { "timestamp":"$(echo $logs | tail -5 | head -1 | awk '{print $1}')",
    "type":"$(echo $logs | tail -5 | head -1 | awk '{print $2}')",
    "message":"$(echo $logs | tail -5 | head -1 | awk '{print $3}')" }
}
EOF
