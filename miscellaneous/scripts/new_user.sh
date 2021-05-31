#!/bin/bash

unset OS_SERVICE_TOKEN
export OS_USERNAME=admin
export OS_PASSWORD='e135ccf06b1e4ff8'
export OS_REGION_NAME=RegionOne
export OS_AUTH_URL=http://10.82.3.90:5000/v3
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_IDENTITY_API_VERSION=3
export STACK_NAME=`grep -w 'user_name' en_var1.yaml | awk {'print $2'}`

echo -n "Creating New User ... "

OUTPUT=`openstack stack create -t heat.yaml -e en_var1.yaml $STACK_NAME`

sleep 5;

echo -e "\e[1;32mDONE\e[0m"

echo -n "Assigning Quota ..... "

unset OS_SERVICE_TOKEN
export OS_USERNAME=`grep -w 'user_name' en_var1.yaml | awk {'print $2'}`
export OS_PASSWORD=`grep -w 'password_v' en_var1.yaml | awk {'print $2'}`
export OS_PROJECT_NAME=`grep -w 'project_name' en_var1.yaml | awk {'print $2'}`

export SWIFT_ACCOUNT=`swift stat | grep -w "Account:" | awk {'print $2'}`

unset OS_SERVICE_TOKEN
export OS_USERNAME=admin
export OS_PASSWORD='e135ccf06b1e4ff8'
export OS_PROJECT_NAME=admin

swift --os-storage-url http://10.82.3.90:8080/v1/$SWIFT_ACCOUNT post -m quota-bytes:5242880

swift --os-storage-url http://10.82.3.90:8080/v1/$SWIFT_ACCOUNT post default

OUTPUT=`swift --os-storage-url http://10.82.3.90:8080/v1/$SWIFT_ACCOUNT upload --segment-container default default ReadMe`

echo -e "\e[1;32mDONE\e[0m"
