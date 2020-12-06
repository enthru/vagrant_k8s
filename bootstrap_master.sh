#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=10.10.10.100 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh

echo "[TASK 5] Deploy other services"
yum -y install unzip git
cd /vagrant
git clone https://github.com/enthru/vagrant_k8s.git
# Deploy flannel network
su - vagrant -c "kubectl create -f /vagrant/vagrant_k8s/kube-flannel.yml"
cd /home/vagrant
git clone https://github.com/enthru/k8s_test.git
cd k8s_test

