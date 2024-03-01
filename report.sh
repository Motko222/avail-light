#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/conf

service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)

if [ $service -eq 1 ]
then status="ok"
else status="error"; note="service not running"
fi

logs=$(journalctl -u availightd --no-hostname -o cat | tail -5)

cat << EOF
{
  "project":"$folder",
  "id":$ID,
  "machine":"$MACHINE",
  "chain":"goldberg",
  "type":"node",
  "status":"$status",
  "note":"$note",
  "service":$service,
  "updated":"$(date --utc +%FT%TZ)",
  "logs": 
  { "timestamp":"$(echo $logs | head -1 | awk '{print $1}')",
    "type":"$(echo $logs | head -1 | awk '{print $2}')",
    "message":"$(echo $logs | head -1 | awk '{print $3}')" }
}
EOF
