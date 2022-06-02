#!/bin/sh
# https://puppet.com/docs/puppet/7/puppet_index.html

#allow puppet traffic
#firewall-cmd --add-port=8140/tcp
#firewall-cmd --add-port=8140/tcp --perm

# Install binaries and chown the config dir to prevent a permission issue
yum -y install puppetserver
chown -R puppet:puppet /etc/puppetlabs

# set java heap appropriately for the VM size
# Default line:
# JAVA_ARGS="-Xms2g -Xmx2g -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger"
# command:
# sed -i 's/{OLD_TERM}/{NEW_TERM}/' {file}
sed -i 's/Xms2g/Xms512m/' /etc/sysconfig/puppetserver
sed -i 's/Xmx2g/Xmx512m/' /etc/sysconfig/puppetserver

# https://puppet.com/docs/puppet/7/dirs_confdir.html
# https://puppet.com/docs/puppet/7/config_file_autosign.html
/opt/puppetlabs/bin/puppet config set server puppet.local --section main

sudo -u puppet tee /etc/puppetlabs/puppet/autosign.conf <<'EOF'
*.local
EOF
systemctl enable --now puppetserver

# configure SSH key for vagrant user to allow puppet-bolt authentication using it
# copy the public key to the /vagrant folder so it's avaiable to the client machines
yum install -y puppet-bolt

# for vagrant user
sudo -u vagrant mkdir -p /home/vagrant/.puppetlabs/etc/bolt/
sudo -u vagrant tee /home/vagrant/.puppetlabs/etc/bolt/bolt-defaults.yaml <<'EOF'
inventory-config:
  ssh:
    private-key: ~/.ssh/id_rsa
    host-key-check: false
EOF
sudo -u vagrant mkdir -p /home/vagrant/.ssh
sudo -u vagrant ssh-keygen -P '' -f /home/vagrant/.ssh/id_rsa
\cp /home/vagrant/.ssh/id_rsa.pub /vagrant/puppet_provision/vagrant_id_rsa.pub

# for root user
mkdir -p /root/.puppetlabs/etc/bolt/
tee /root/.puppetlabs/etc/bolt/bolt-defaults.yaml <<'EOF'
inventory-config:
  ssh:
    private-key: ~/.ssh/id_rsa
    host-key-check: false
EOF

#include the backslash to force the unalised version of the CP command to allow the force
mkdir -p /root/.ssh
ssh-keygen -P '' -f /root/.ssh/id_rsa
\cp /root/.ssh/id_rsa.pub /vagrant/puppet_provision/root_id_rsa.pub

# ------------------------------------------------------------------------------
# Next Step
# PuppetDB
# https://puppet.com/docs/puppetdb/7/install_via_module.html
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Puppet Dev Code Setup
# ------------------------------------------------------------------------------
# Assumeses there is a "manifests" and "modules" dirs under the top level of this 
# project, that will hold the puppet module projects being developed.
# These folders are excluded from the project, and should be created in the project
# manually, and have the module projects added below them as required.
# 
# not sure if this is the best way to do it yet...
# need to check on applying code from "code/modules" vs. "environments/modules"


#setup dev modules directory
# skipping the manifests folder so that the agent VMs don't apply configs yet
#if [ -d /vagrant/manifests ] ; then
#  rmdir /etc/puppetlabs/code/environments/production/manifests
#  ln -s /vagrant/manifests /etc/puppetlabs/code/environments/production/
#fi

if [ -d /vagrant/modules ] ; then
  rmdir /etc/puppetlabs/code/environments/production/modules
  ln -s /vagrant/modules /etc/puppetlabs/code/environments/production/
fi
