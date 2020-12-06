# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  config.vm.define "master" do |master|
    master.vm.box = "centos/7"
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "10.10.10.100"
    master.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.memory = 2048
      v.cpus = 2
    end
    master.vm.provision "shell", path: "bootstrap_master.sh"
  end

  NodeCount = 2

  (1..NodeCount).each do |i|
    config.vm.define "slave#{i}" do |slavenode|
      slavenode.vm.box = "centos/7"
      slavenode.vm.hostname = "slave#{i}"
      slavenode.vm.network "private_network", ip: "10.10.10.20#{i}"
      slavenode.vm.provider "virtualbox" do |v|
        v.name = "slave#{i}"
        v.memory = 2048
        v.cpus = 2
      end
      slavenode.vm.provision "shell", path: "bootstrap_slave.sh"
    end
  end

end
