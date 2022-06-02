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
# If the example modules were linked via Vagrant, then we will need some 
# additional modules installed, etc..
if [ -d /etc/puppetlabs/code/environments/example/modules ] ; then
  sudo /opt/puppetlabs/bin/puppet module install --target-dir /etc/puppetlabs/code/environments/example/modules/ puppetlabs-postgresql
  sudo /opt/puppetlabs/bin/puppet module install --target-dir /etc/puppetlabs/code/environments/example/modules/ puppetlabs-firewall
  chown -R puppet:puppet /etc/puppetlabs/code/environments/example/
fi
