#!/bin/bash

network=$(curl -s --location --request GET 'http://'"$IP"':9696/v2.0/networks.json?fields=id&fields=name&fields=status' --header "X-Auth-Token: $OS_TOKEN" | jq '.networks[] | {id:.id ,name:.name,status:.status }' --compact-output)

echo "{ \"networks\":";echo "[";

for i in $(for i in $network; do echo "$i";done); do echo "$i,";done | sed '$ s,.$,,'
echo "] 
}";