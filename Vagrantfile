# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.require_version ">=1.8"

#Puppet Master Server
Vagrant.configure("2") do |config|
  boxdir = ENV['VAGRANT_BOX_DIR']
  config.vm.box = "#{boxdir}/packer_centos7_virtualbox.box"

  config.vm.provision "file", source: "puppet_provision", destination: "puppet_provision"

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 1
    v.customize ['modifyvm',:id, '--nictype1', 'virtio']
    v.customize ['modifyvm',:id, '--nictype1', 'virtio']
  end
  
  config.vm.define :puppet do |puppet|
    puppet.vm.hostname = "puppet.local"
    puppet.vm.network "private_network", ip: "192.168.52.100", nic_type: "virtio", virtualbox__intnet: "puppetnetwork"
    puppet.vm.network "forwarded_port", guest: 22, host: 52022, host_ip: '127.0.0.1', protocol: 'tcp'
    puppet.vm.provision "shell", inline: <<-SHELL
      /vagrant/puppet_provision/common.sh
      /vagrant/puppet_provision/puppet_server.sh
    SHELL
  end

  config.vm.define :web do |web|
    web.vm.hostname = "web.local"
    web.vm.network "private_network", ip: "192.168.52.101", nic_type: "virtio", virtualbox__intnet: "puppetnetwork"
    web.vm.network "forwarded_port", guest: 22, host: 52122, host_ip: '127.0.0.1', protocol: 'tcp'
    web.vm.provision "shell", inline: <<-SHELL
      /vagrant/puppet_provision/common.sh
      /vagrant/puppet_provision/puppet_agent.sh
    SHELL
  end

  config.vm.define :db do |web|
    web.vm.hostname = "db.local"
    web.vm.network "private_network", ip: "192.168.52.102", nic_type: "virtio", virtualbox__intnet: "puppetnetwork"
    web.vm.network "forwarded_port", guest: 22, host: 52222, host_ip: '127.0.0.1', protocol: 'tcp'
    web.vm.provision "shell", inline: <<-SHELL
      /vagrant/puppet_provision/common.sh
      /vagrant/puppet_provision/puppet_agent.sh
    SHELL
  end
end
