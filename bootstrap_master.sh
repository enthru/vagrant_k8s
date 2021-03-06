#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=10.10.10.100 --pod-network-cidr=10.224.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo "[TASK 3] Deploy Calico network"
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh

echo "[TASK 5] Deploy other services"
yum -y install unzip git
git clone https://github.com/enthru/k8s_test.git
cd k8s_test
su - vagrant -c "kubectl apply -f service/zookeeper-svc.yaml"
su - vagrant -c "kubectl apply -f statefulset/zookeeper-statefulset.yaml"
sleep 300
su - vagrant -c "kubectl apply -f service/kafka-svc.yaml"
su - vagrant -c "kubectl apply -f statefulset/kafka-statefulset.yaml"
sleep 300
kubectl run producer-app --image=enthru/producer:v1.2
kubectl run consumer-app --image=enthru/consumer:v1.0

