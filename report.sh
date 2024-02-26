#!/bin/bash


service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)

if [ $service -eq 1 ]
then status="ok"
else status="error" note="service not running"
fi

tee | jq << EOF
{
  "project":"$project",
  "id":$id,
  "machine":"$machine",
  "status":"$status",
  "note":"$note",
  "service":$service
}
EOF
