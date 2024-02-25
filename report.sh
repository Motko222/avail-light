#!/bin/bash


service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)

[ $service -ne 1 ] && status="error";note="service not running" || status="ok"

tee | jq << EOF
{
  "status"="$status",
  "note"="$note",
  "service"=$service
}
EOF
