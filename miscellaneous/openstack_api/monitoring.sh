#!/bin/bash

IP=$1

#OS_TOKEN=$(curl -i -s -H "Content-Type: application/json"   -d '
#{ "auth": {
#"identity": {
#"methods": ["password"],
#"password": {
#"user": {
#"name": "admin",
#"domain": { "id": "default" },
#"password": "HYX9PtzTOxSdKk7mTWiU1SkQw"
#}
#}
#}
#}
#}'   "http://10.82.1.100:5000/v3/auth/tokens" | grep -w "X-Subject-Token" | awk '{print $2}')
# echo $OS_TOKEN
OS_TOKEN=${OS_TOKEN::-1}
# echo $OS_TOKEN
OS_TOKEN=${OS_TOKEN//$'\015'}
# echo $OS_TOKEN
# OS_TOKEN=gAAAAABgdBWbiayQDwFl0UULUi50bgXtgYkXzh-gnDMib0Jx1rmwMfdeGPndiqK9VWqQ14fKCRBy_ovBqDrUoIAfMIYvN_rklPa_4jb3TILt7SZPI1KvcTih7H1jZ78MTt-NlASwuY_w6_LvUUceEAqPK7DGqVDgpw
echo "[
  {
\"servers\": 
["
for i in $(for i in `curl -s --location --request GET 'http://'"$IP"':8774/v2.1/servers/detail' --header 'Content-Type: application/json' --header 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.servers[] | { id:.id, name:.name, status:.status }' --compact-output
`; do echo "$i";done); do echo "$i,";done | sed '$ s,.$,,' 
echo "]
},"

network=$(curl -s --location --request GET 'http://'"$IP"':9696/v2.0/networks.json?fields=id&fields=name&fields=status' --header "X-Auth-Token: $OS_TOKEN" | jq '.networks[] | {id:.id ,name:.name,status:.status }' --compact-output)
echo "{ \"networks\":";echo "["
for i in $(for i in $network; do echo "$i";done); do echo "$i,";done | sed '$ s,.$,,'
echo "] 
},"

export ROUTER_ID=$(curl -s -L -g -X GET 'http://'"$IP"':9696/v2.0/routers' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.routers[].id' --compact-output  | sed -e 's/^"//' -e 's/"$//')

export TEMP_OUTPUT=$(echo "{
\"routers\": 
[" 
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
done 
echo "
]
}";)
export OUTPUT=${TEMP_OUTPUT::-6}
echo $(echo "$OUTPUT ]}") | python -mjson.tool

echo "]"
