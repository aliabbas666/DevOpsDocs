#!/bin/bash

export ROUTER_ID=$(curl -s -L -g -X GET 'http://'"$IP"':9696/v2.0/routers' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.routers[].id' --compact-output  | sed -e 's/^"//' -e 's/"$//')

export TEMP_OUTPUT=$(echo "{
\"routers\": 
[" &&
for j in $ROUTER_ID;
do 
export IFACES=$(curl  -s -L -g -X GET 'http://'"$IP"':9696/v2.0/ports?device_id='"$j"'' \
--header 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.ports[] | {id:.id, status:.status }' --compact-output)
echo "
{
\"name\": \" `curl -s -L -g -X GET 'http://'"$IP"':9696/v2.0/routers/'"$j"'' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.router.name' | sed -e 's/^"//' -e 's/"$//'`\",
\"interfaces\": [ 
  `for i in $(for i in $IFACES; do echo "$i";done); do echo "$i,";done | sed '$ s,.$,,'` ] 
}," 
done &&
echo "
]
}";)
export OUTPUT=${TEMP_OUTPUT::-6}
echo $(echo "$OUTPUT ]}")
