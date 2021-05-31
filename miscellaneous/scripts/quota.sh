#!/bin/bash

export OS_REGION_NAME=RegionOne
export OS_AUTH_URL=http://10.82.3.90:5000/v3
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_IDENTITY_API_VERSION=3
export OS_USERNAME=`grep -w 'user_name' en_var1.yaml | awk {'print $2'}`
export OS_PASSWORD=`grep -w 'password_v' en_var1.yaml | awk {'print $2'}`
export OS_PROJECT_NAME=`grep -w 'project_name' en_var1.yaml | awk {'print $2'}`
export QUOTA=`grep -w 'quota' en_var1.yaml | awk {'print $2'}`

export SWIFT_ACCOUNT=`swift stat | grep -w "Account:" | awk {'print $2'}`

unset OS_SERVICE_TOKEN
export OS_USERNAME=admin
export OS_PASSWORD='e135ccf06b1e4ff8'
export OS_PROJECT_NAME=admin

echo -ne "Setting Quota to $QUOTA bytes ... "

swift --os-storage-url http://10.82.3.90:8080/v1/$SWIFT_ACCOUNT post -m quota-bytes:$QUOTA

echo -e "\e[1;32mDONE\e[0m"