#!/bin/bash

yellow=`tput setaf 3`
reset=`tput sgr0`

echo "${yellow}==============================================================================================================================================================================="
echo "                                                                      Installing Docker"
echo "===============================================================================================================================================================================${reset}"

sudo apt-get update -y
sudo apt-get install -y\
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

echo "${yellow}==============================================================================================================================================================================="
echo "                                                                      Installing Kolla-Ansible"
echo "===============================================================================================================================================================================${reset}"

sudo apt-get install python3-dev libffi-dev gcc libssl-dev python-dockerpty python3-pip -y
sudo pip3 install -U pip
sudo pip3 install -U 'ansible==2.9'
sudo pip3 install kolla kolla-ansible
sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla
cp -r /usr/local/share/kolla-ansible/etc_examples/kolla/* /etc/kolla

