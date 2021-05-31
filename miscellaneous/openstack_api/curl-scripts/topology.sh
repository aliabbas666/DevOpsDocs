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

#Create BLUE Network
export BLUE_NETWORK_ID=$(curl -s -L -X POST 'http://'"$IP"':9696/v2.0/networks/' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "networks": [
        {
            "name": "BLUE",
            "admin_state_up": true
        }
    ]
}'| jq '.networks[].id' | sed -e 's/^"//' -e 's/"$//')

#Create BLUE Subnet

export BLUE_SUBNET_ID=$(curl -s -L -X POST 'http://'"$IP"':9696/v2.0/subnets' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "subnet": {
        "name": "BLUE_SUBNET",
        "network_id": "'"$BLUE_NETWORK_ID"'",
        "ip_version": 4,
        "cidr": "10.0.0.0/24"
    }
}' | jq '.subnet.id' | sed -e 's/^"//' -e 's/"$//')

#Create RED Network
export RED_NETWORK_ID=$(curl -s -L -X POST 'http://'"$IP"':9696/v2.0/networks/' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "networks": [
        {
            "name": "RED",
            "admin_state_up": true
        }
    ]
}'| jq '.networks[].id' | sed -e 's/^"//' -e 's/"$//')

#Create RED Subnet
export RED_SUBNET_ID=$(curl -s -L -X POST 'http://'"$IP"':9696/v2.0/subnets' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "subnet": {
        "name": "RED_SUBNET",
        "network_id": "'"$RED_NETWORK_ID"'",
        "ip_version": 4,
        "cidr": "192.168.1.0/24"
    }
}' | jq '.subnet.id' | sed -e 's/^"//' -e 's/"$//')

#Create PUBLIC Network
export PUBLIC_NETWORK_ID=$(curl -s -L -X POST 'http://'"$IP"':9696/v2.0/networks/' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "networks": [
        {
            "name": "PUBLIC",
            "admin_state_up": true
        }
    ]
}'| jq '.networks[].id' | sed -e 's/^"//' -e 's/"$//')


#Create PUBLIC Subnet
export PUBLIC_SUBNET_ID=$(curl -s -L -X POST 'http://'"$IP"':9696/v2.0/subnets' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "subnet": {
        "name": "PUBLIC_SUBNET",
        "network_id": "'"$PUBLIC_NETWORK_ID"'",
        "ip_version": 4,
        "cidr": "172.24.4.0/24"
    }
}' | jq '.subnet.id' | sed -e 's/^"//' -e 's/"$//')

echo -e "\e[1;32mNetworks Created\e[0m"

#Create Router
export ROUTER_ID=$(curl -s -L -X POST 'http://'"$IP"':9696/v2.0/routers' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "router": {
        "name": "ROUTER",
        "admin_state_up": true
    }
}'| jq '.router.id' | sed -e 's/^"//' -e 's/"$//')

#Create BLUE Subnet to Router
export IFACE_ID=$(curl -s -L -g -X PUT 'http://'"$IP"':9696/v2.0/routers/'"$ROUTER_ID"'/add_router_interface' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "subnet_id": "'"$BLUE_SUBNET_ID"'"
}'| jq '.id' | sed -e 's/^"//' -e 's/"$//')

#Create RED Subnet to Router
export IFACE_ID=$(curl -s -L -g -X PUT 'http://'"$IP"':9696/v2.0/routers/'"$ROUTER_ID"'/add_router_interface' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "subnet_id": "'"$RED_SUBNET_ID"'"
}'| jq '.id' | sed -e 's/^"//' -e 's/"$//')

#Create PUBLIC Subnet to Router
export IFACE_ID=$(curl -s -L -g -X PUT 'http://'"$IP"':9696/v2.0/routers/'"$ROUTER_ID"'/add_router_interface' -H 'Content-Type: application/json' -H 'X-Auth-Token: '"$OS_TOKEN"'' --data-raw '{
    "subnet_id": "'"$PUBLIC_SUBNET_ID"'"
}'| jq '.id' | sed -e 's/^"//' -e 's/"$//')

echo -e "\e[1;32mRouter Created\e[0m"

#Get Flavor ID
export FLAVOR_ID=$(curl -s -L -X GET 'http://'"$IP"'/compute/v2.1/flavors' -H 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.flavors[] | {id:.id , name:.name}' --compact-output | grep m1.nano | jq '.id' | sed -e 's/^"//' -e 's/"$//')

#Get Image ID
export IMG_ID=$(curl -s -L -g -X GET 'http://'"$IP"'/image/v2/images' -H 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.images[] | {id:.id , name:.name}' --compact-output | grep -i cirros | jq '.id' | sed -e 's/^"//' -e 's/"$//')

#Create Server in BLUE Network
export BLUE_VM_ID=$(curl -s -L -g -X POST 'http://'"$IP"'/compute/v2.1/servers' -H 'X-Auth-Token: '"$OS_TOKEN"'' -H 'Content-Type: application/json' --data-raw '{
    "server" : {
        "name" : "VM1",
        "imageRef" : "'"$IMG_ID"'",
        "flavorRef" : "'"$FLAVOR_ID"'",
        "OS-DCF:diskConfig": "AUTO",
        "networks" : [{
            "uuid" : "'"$BLUE_NETWORK_ID"'"
        }],
        "security_groups": [
            {
                "name": "default"
            }
        ]
    }
}'
)

#Create Server in RED Network
export RED_VM_ID=$(curl -s -L -g -X POST 'http://'"$IP"'/compute/v2.1/servers' -H 'X-Auth-Token: '"$OS_TOKEN"'' -H 'Content-Type: application/json' --data-raw '{
    "server" : {
        "name" : "VM2",
        "imageRef" : "'"$IMG_ID"'",
        "flavorRef" : "'"$FLAVOR_ID"'",
        "OS-DCF:diskConfig": "AUTO",
        "networks" : [{
            "uuid" : "'"$RED_NETWORK_ID"'"
        }],
        "security_groups": [
            {
                "name": "default"
            }
        ]
    }
}'
)

#Create Server in PPUBLIC Network
export PUBLIC_VM_ID=$(curl -s -L -g -X POST 'http://'"$IP"'/compute/v2.1/servers' -H 'X-Auth-Token: '"$OS_TOKEN"'' -H 'Content-Type: application/json' --data-raw '{
    "server" : {
        "name" : "VM3",
        "imageRef" : "'"$IMG_ID"'",
        "flavorRef" : "'"$FLAVOR_ID"'",
        "OS-DCF:diskConfig": "AUTO",
        "networks" : [{
            "uuid" : "'"$PUBLIC_NETWORK_ID"'"
        }],
        "security_groups": [
            {
                "name": "default"
            }
        ]
    }
}'
)

echo -e "\e[1;32mVMs Spawned\e[0m"
