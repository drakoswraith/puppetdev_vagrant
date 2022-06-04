# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.require_version ">=1.8"

#Puppet Master Server
Vagrant.configure("2") do |config|
  if ENV['PDV_CONFIGEXAMPLES'] == 'true'
    disable_examples = false
  else
    disable_examples = true
  end
  
  boxdir = ENV['VAGRANT_BOX_DIR']
  config.vm.box = "#{boxdir}/packer_centos7_virtualbox.box"

  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.customize ['modifyvm',:id, '--nictype1', 'virtio']
    v.customize ['modifyvm',:id, '--nictype1', 'virtio']
  end
  
  config.vm.define :puppet do |puppet|
    puppet.vm.hostname = "puppet.local"
    puppet.vm.network "private_network", ip: "192.168.52.100", nic_type: "virtio", virtualbox__intnet: "puppetnetwork"
    puppet.vm.network "forwarded_port", guest: 22, host: 52022, host_ip: '127.0.0.1', protocol: 'tcp'
    puppet.vm.network "forwarded_port", guest: 8080, host: 52080, host_ip: '127.0.0.1', protocol: 'tcp'
    puppet.vm.provider "virtualbox" do |vp|
      vp.memory = 2048
      vp.cpus = 2
    end

    if ENV['PDV_CONFIGEXAMPLES'] == 'true'
      # mount the example puppet modules and manifests for availability
      puppet.vm.synced_folder "example_env/data", "/etc/puppetlabs/code/environments/example/data", create: true, disabled: disable_examples
      puppet.vm.synced_folder "example_env/manifests", "/etc/puppetlabs/code/environments/example/manifests", create: true, disabled: disable_examples
      puppet.vm.synced_folder "example_env/site", "/etc/puppetlabs/code/environments/example/site", create: true, disabled: disable_examples
      puppet.vm.synced_folder "example_env/modules/funwithfacts", "/etc/puppetlabs/code/environments/example/modules/funwithfacts", create: true, disabled: disable_examples
      puppet.vm.synced_folder "example_env/modules/nixmotd", "/etc/puppetlabs/code/environments/example/modules/nixmotd", create: true, disabled: disable_examples
      puppet.vm.synced_folder "example_env/modules/pasture", "/etc/puppetlabs/code/environments/example/modules/pasture", create: true, disabled: disable_examples
      config.vm.synced_folder "example_env/", "/etc/puppetlabs/code/environments/example/", type: "rsync",  rsync__args: ["-r", "--include=environment.conf", "--include=hiera.yaml", "--exclude=*"]
    end

    puppet.vm.provision "shell", inline: <<-SHELL
      /vagrant/puppet_provision/common.sh
      /vagrant/puppet_provision/puppet_server.sh
    SHELL
  end

  config.vm.define :web do |web|
    web.vm.hostname = "web.local"
    web.vm.network "private_network", ip: "192.168.52.101", nic_type: "virtio", virtualbox__intnet: "puppetnetwork"
    web.vm.network "forwarded_port", guest: 22, host: 52122, host_ip: '127.0.0.1', protocol: 'tcp'
    web.vm.provider "virtualbox" do |vweb|
      vweb.memory = 1024
      vweb.cpus = 1
    end
    web.vm.provision "shell", inline: <<-SHELL
      /vagrant/puppet_provision/common.sh
      /vagrant/puppet_provision/puppet_agent.sh
    SHELL
    if ENV['PDV_CONFIGEXAMPLES'] == 'true'
      web.vm.provision "shell", inline: <<-SHELL
        /opt/puppetlabs/bin/puppet config set environment example --section agent
      SHELL
    end
    web.vm.provision "shell", inline: <<-SHELL
      /vagrant/puppet_provision/puppet_start_agent.sh
    SHELL
  end

  config.vm.define :db do |db|
    db.vm.hostname = "db.local"
    db.vm.network "private_network", ip: "192.168.52.102", nic_type: "virtio", virtualbox__intnet: "puppetnetwork"
    db.vm.network "forwarded_port", guest: 22, host: 52222, host_ip: '127.0.0.1', protocol: 'tcp'
    db.vm.provider "virtualbox" do |vdb|
      vdb.memory = 1024
      vdb.cpus = 1
    end
    db.vm.provision "shell", inline: <<-SHELL
      /vagrant/puppet_provision/common.sh
      /vagrant/puppet_provision/puppet_agent.sh
    SHELL
    if ENV['PDV_CONFIGEXAMPLES'] == 'true'
      db.vm.provision "shell", inline: <<-SHELL
        /opt/puppetlabs/bin/puppet config set environment example --section agent
      SHELL
    end
    db.vm.provision "shell", inline: <<-SHELL
      /vagrant/puppet_provision/puppet_start_agent.sh
    SHELL
  end
end
