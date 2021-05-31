#!/bin/bash

IP=$1

OS_TOKEN=$(curl -i -s -H "Content-Type: application/json"   -d '
{ "auth": {                                  
        "identity": {                        
          "methods": [                     
          "password"                   
        ],                               
        "password": {                    
        "user": {                    
        "domain": {"id": "default"},                                           
        "name": "admin",         
        "password": "secret"     
        }                            
        }                                
        },                                   
        "scope": {                           
        "project": {                     
        "id": "187d635aec4c43fe8e8918afb3a5c82e"                                   
      }                                
    }                                    
  }                                        
}' "http://$IP/identity/v3/auth/tokens" | grep -w "X-Subject-Token" | awk '{print $2}')    
OS_TOKEN=${OS_TOKEN//$'\015'}

echo "[
  {
\"servers\": 
["
for i in $(for i in `curl -s --location --request GET 'http://'"$IP"'/compute/v2.1/servers/detail' --header 'Content-Type: application/json' --header 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.servers[] | { id:.id, name:.name, status:.status }' --compact-output
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
\"routers\": ["
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
echo $(echo "$OUTPUT ]}")

echo "]"
