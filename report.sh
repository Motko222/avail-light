#!/bin/bash


service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)

if [ $service -ne 1 ]
then 
  status="error";
  note="service not running"
else 
  status="ok";
fi

tee << EOF
{
  "status"="$status",
  "service"="$service"
}
EOF
