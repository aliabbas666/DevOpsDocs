#!/bin/bash

openstack server delete VM1
openstack server delete VM2
openstack server delete VM3
echo -e "\e[1;31mVMs Removed \e[0m"

sleep 3

port=$(openstack port list | awk {'print $2'} | sed 's/ID//')
for i in $port;
  do
     openstack router remove port ROUTER $i
done

openstack router delete ROUTER
echo -e "\e[1;31mRouter Removed \e[0m"

openstack network delete RED
openstack network delete BLUE
openstack network delete PUBLIC
echo -e "\e[1;31mNetworks Removed \e[0m"
