#!/bin/bash
source ~/scripts/avail-light/config/env

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)

if [ $service -eq 1 ]
then status="ok"
else status="error" note="service not running"
fi

tee | jq << EOF
{
  "project":"$folder",
  "id":$ID,
  "machine":"$MACHINE",
  "chain":"$CHAIN",
  "status":"$status",
  "note":"$note",
  "service":$service
}
EOF
