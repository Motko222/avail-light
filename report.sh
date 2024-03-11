#!/bin/bash

source ~/.bash_profile

service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)
id=avail-$AVAIL_ID
chain=goldberg
bucket=$AVAIL_BUCKET

if [ $service -eq 1 ]
then status="ok"
else status="error"; message="service not running"
fi

cat << EOF
{
  "project":"$folder",
  "id":"$id",
  "machine":"$MACHINE",
  "chain":"$chain",
  "type":"node",
  "status":"$status",
  "message":"$message",
  "service":$service,
  "updated":"$(date --utc +%FT%TZ)"
}
EOF

# send data to influxdb
if [ ! -z $INFLUX_HOST ]
then
 curl --request POST \
 "$INFLUX_HOST/api/v2/write?org=$INFLUX_ORG&bucket=$bucket&precision=ns" \
  --header "Authorization: Token $INFLUX_TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary "
    status,node=$id,machine=$MACHINE status=\"$status\",message=\"$message\",version=\"$version\",url=\"$url\",chain=\"$chain\" $(date +%s%N) 
    "
fi
