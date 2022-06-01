#!/bin/sh

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

sudo -u vagrant mkdir -p /home/vagrant/.puppetlabs/etc/bolt/
sudo -u vagrant tee /home/vagrant/.puppetlabs/etc/bolt/bolt-defaults.yaml <<'EOF'
inventory-config:
  ssh:
    private-key: ~/.ssh/id_rsa
    host-key-check: false
EOF

sudo -u vagrant mkdir -p /home/vagrant/.ssh
sudo -u vagrant ssh-keygen -P '' -f /home/vagrant/.ssh/id_rsa
chmod 600 /vagrant/.ssh/id_rsa

#include the backslash to force the unalised version of the CP command to allow the force
\cp /home/vagrant/.ssh/id_rsa.pub /vagrant/puppet_provision/vagrant_id_rsa.pub

# ------------------------------------------------------------------------------
# Next Step
# PuppetDB
# https://puppet.com/docs/puppetdb/7/install_via_module.html
# ------------------------------------------------------------------------------
