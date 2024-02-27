#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)

if [ $service -eq 1 ]
then status="ok"
else status="error"; note="service not running"
fi

tee | jq << EOF
{
  "project":"$folder",
  "id":$AVAIL_ID,
  "machine":"$MACHINE",
  "chain":"$AVAIL_CHAIN",
  "type":"node",
  "status":"$status",
  "note":"$note",
  "service":$service,
  "updated":"$(date --utc +%FT%TZ)"
}
EOF
