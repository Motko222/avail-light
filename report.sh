#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/conf

service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)

if [ $service -eq 1 ]
then status="ok"
else status="error"; note="service not running"
fi

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
  "updated":"$(date --utc +%FT%TZ)"
}
EOF
