#!/bin/sh
sudo yum -y install puppet-agent puppet-bolt
sudo chown -R puppet:puppet /etc/puppetlabs
sudo /opt/puppetlabs/bin/puppet config set server puppet.local --section main
sudo /opt/puppetlabs/bin/puppet ssl bootstrap || :
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
