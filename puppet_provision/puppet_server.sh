#!/bin/sh

#allow puppet traffic
#firewall-cmd --add-port=8140/tcp
#firewall-cmd --add-port=8140/tcp --perm

# Install binaries and chown the config dir to prevent a permission issue
sudo yum -y install puppetserver
sudo chown -R puppet:puppet /etc/puppetlabs

#sudo /opt/puppetlabs/bin/puppet config set waitforcert 0

# set java heap appropriately for the VM size
# Default line:
# JAVA_ARGS="-Xms2g -Xmx2g -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger"
# command:
# sed -i 's/{OLD_TERM}/{NEW_TERM}/' {file}
sudo sed -i 's/Xms2g/Xms512m/' /etc/sysconfig/puppetserver
sudo sed -i 's/Xmx2g/Xmx512m/' /etc/sysconfig/puppetserver

# https://puppet.com/docs/puppet/7/dirs_confdir.html
# https://puppet.com/docs/puppet/7/config_file_autosign.html
sudo /opt/puppetlabs/bin/puppet config set server puppet.local --section main
sudo /opt/puppetlabs/bin/puppet config set autosign true --section "primary server"

sudo tee /etc/puppetlabs/puppet/autosign.conf <<'EOF'
*.local
EOF
sudo chown puppet:puppet /etc/puppetlabs/puppet/autosign.confs

# enable service
sudo systemctl enable --now puppetserver

