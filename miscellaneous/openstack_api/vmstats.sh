#!/bin/bash
echo "{
\"servers\": 
[" &&
for i in $(for i in `curl -s --location --request GET 'http://'"$IP"':8774/v2.1/servers/detail' --header 'Content-Type: application/json' --header 'X-Auth-Token: '"$OS_TOKEN"'' | jq '.servers[] | { id:.id, name:.name, status:.status }' --compact-output
`; do echo "$i";done); do echo "$i,";done | sed '$ s,.$,,' &&
echo "]
}"