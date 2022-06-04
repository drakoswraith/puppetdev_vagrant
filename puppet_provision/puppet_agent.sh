#!/bin/sh
# set the SSH key for puppet-bolt and ssh auth to work
mkdir -p /home/vagrant/.ssh
cat /vagrant/puppet_provision/vagrant_id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

mkdir -p /root/.ssh
cat /vagrant/puppet_provision/root_id_rsa.pub >> /root/.ssh/authorized_keys

yum -y install puppet-agent puppet-bolt
/opt/puppetlabs/bin/puppet config set server puppet.local --section main 
/opt/puppetlabs/bin/puppet ssl bootstrap || :
