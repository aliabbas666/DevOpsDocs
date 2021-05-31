source /home/stack/overcloudrc

openstack network create --external --project service --external  --provider-network-type flat --provider-physical-network datacentre external

openstack subnet create  --project service --no-dhcp --network external --gateway 10.81.1.250  --allocation-pool start=10.81.1.21,end=10.81.1.89 --subnet-range 10.81.1.0/24 external-subnet 

openstack image create cirros --public --file ./cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare

openstack flavor create m1.tiny --ram 512 --disk 1 --public

openstack flavor create m1.medium --ram 4096 --vcpu 2 --public

openstack network create net_test --provider-network-type=geneve --provider-segment 100

openstack subnet create --network net_test --subnet-range 192.168.123.0/24 test

openstack router create test

openstack router set test --external-gateway external

openstack router add subnet test test

admin_project_id=$(openstack project list | grep admin | awk '{print $2}') 

admin_sec_group_id=$(openstack security group list | grep $admin_project_id | awk '{print $2}')
openstack security group rule create $admin_sec_group_id --protocol icmp --ingress 
openstack security group rule create $admin_sec_group_id --protocol icmp --egress
openstack security group rule create $admin_sec_group_id --protocol udp --ingress
openstack security group rule create  $admin_sec_group_id --protocol udp --egress
openstack security group rule create  $admin_sec_group_id --protocol tcp  --ingress
openstack security group rule create  $admin_sec_group_id --protocol tcp  --egress
openstack security group rule create $admin_sec_group_id --protocol tcp --dst-port 22 --ingress
openstack security group rule create $admin_sec_group_id --protocol tcp --dst-port 22 --egress

openstack flavor create  'ECS General-2 1vCPU 2GB Linux On-Demand'  --vcpus 1      --ram    2048
openstack flavor create  'ECS General-2 2vCPU 4GB Linux On-Demand'  --vcpus 2    --ram    4096
openstack flavor create  'ECS General-2 4vCPU 8GB Linux On-Demand'  --vcpus 4    --ram    8192
openstack flavor create  'ECS Compute-1 1vCPU 1GB Linux On-Demand'  --vcpus 1    --ram    1024
openstack flavor create  'ECS Compute-1 2vCPU 2GB Linux On-Demand'  --vcpus 2    --ram    2048
openstack flavor create  'ECS Compute-1 4vCPU 4GB Linux On-Demand'  --vcpus 4    --ram    4096
openstack flavor create 'ECS General-2 1vCPU 2GB Linux RI 1 Year Partial UpFront'  --vcpus 1 --ram 2048
openstack flavor create 'ECS General-2 2vCPU 4GB Linux RI 1 Year Partial UpFront'  --vcpus 2 --ram 4096
openstack flavor create 'ECS General-2 4vCPU 8GB Linux RI 1 Year Partial UpFront'  --vcpus 4  --ram 8192

openstack project create Dev
openstack user create --project Dev --password letmein dev-admin
openstack role add  --project Dev --user dev-admin admin 

openstack user create --project Dev --password letmein qa
openstack role add  --project Dev --user qa  _member_

openstack service create monitoring --name monasca  --description "Monasca monitoring"
openstack endpoint create monasca  --region Riyadh public  http://10.81.1.74:8070/v2.0
openstack endpoint create monasca  --region Riyadh internal  http://10.81.1.74:8070/v2.0
openstack endpoint create monasca  --region Riyadh admin http://10.81.1.74:8070/v2.0
