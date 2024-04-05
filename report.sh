#!/bin/bash

source ~/.bash_profile
id=avail-$AVAIL_ID
chain=goldberg
bucket=node

version=$(/root/.avail/bin/avail-light -V | awk '{print $2}')

health=$(curl -sS -I "http://localhost:7000/health" | head -1 | awk '{print $2}')
if [ -z $health ]; then health=null; fi
case $health in
 200) status=ok ;;
 *)   status=warning;message="health - $health" ;;
esac

service=$(sudo systemctl status availightd --no-pager | grep "active (running)" | wc -l)
if [ $service -ne 1 ]
then status="error"; message="service not running"
fi

cat << EOF
{
  "id":"$id",
  "machine":"$MACHINE",
  "version":"$version",
  "chain":"$chain",
  "type":"node",
  "status":"$status",
  "message":"$message",
  "service":$service,
  "health":$health,
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
