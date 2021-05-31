#!/bin/bash
openstack flavor create  "HANA 40vCPU 160GB On-Demand" --vcpus 40 --ram 163840
openstack flavor create  "HANA 64vCPU 256GB On-Demand" --vcpus 64 --ram 262144
openstack flavor create  "HANA 8vCPU 64GB On-Demand" --vcpus 8 --ram 65536
openstack flavor create  "HANA 10vCPU 80GB On-Demand" --vcpus 10 --ram 81920
openstack flavor create  "HANA 12vCPU 96GB On-Demand" --vcpus 12 --ram 98304
openstack flavor create  "HANA 14vCPU 112GB On-Demand" --vcpus 14 --ram 114688
openstack flavor create  "HANA 16vCPU 128GB On-Demand" --vcpus 16 --ram 131072
openstack flavor create  "HANA 18vCPU 144GB On-Demand" --vcpus 18 --ram 147456
openstack flavor create  "HANA 32vCPU 256GB On-Demand" --vcpus 32 --ram 262144
openstack flavor create  "HANA 64vCPU 512GB On-Demand" --vcpus 64 --ram 524288