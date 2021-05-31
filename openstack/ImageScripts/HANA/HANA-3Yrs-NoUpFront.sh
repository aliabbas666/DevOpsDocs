#!/bin/bash
openstack flavor create  "HANA 40vCPU 160GB 3Yrs NoUpFront" --vcpus 40 --ram 163840
openstack flavor create  "HANA 64vCPU 256GB 3Yrs NoUpFront" --vcpus 64 --ram 262144
openstack flavor create  "HANA 8vCPU 64GB 3Yrs NoUpFront" --vcpus 8 --ram 65536
openstack flavor create  "HANA 10vCPU 80GB 3Yrs NoUpFront" --vcpus 10 --ram 81920
openstack flavor create  "HANA 12vCPU 96GB 3Yrs NoUpFront" --vcpus 12 --ram 98304
openstack flavor create  "HANA 14vCPU 112GB 3Yrs NoUpFront" --vcpus 14 --ram 114688
openstack flavor create  "HANA 16vCPU 128GB 3Yrs NoUpFront" --vcpus 16 --ram 131072
openstack flavor create  "HANA 18vCPU 144GB 3Yrs NoUpFront" --vcpus 18 --ram 147456
openstack flavor create  "HANA 32vCPU 256GB 3Yrs NoUpFront" --vcpus 32 --ram 262144
openstack flavor create  "HANA 64vCPU 512GB 3Yrs NoUpFront" --vcpus 64 --ram 524288