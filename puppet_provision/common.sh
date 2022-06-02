#!/bin/sh

#update Sudoers to include Puppet path for vagrant user
cat /vagrant/puppet_provision/vagrant.sudoers.d > /etc/sudoers.d/vagrant

#Update Bash profile to add puppet to profile
tee /root/.bash_profile <<'EOF'
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:/opt/puppetlabs/bin:$HOME/bin

export PATH
EOF

tee /home/vagrant/.bash_profile <<'EOF'
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:/opt/puppetlabs/bin:$HOME/bin

export PATH
EOF

#Setup Hosts file 
tee -a /etc/hosts <<'EOF'
192.168.52.100  puppet puppet.local
192.168.52.101  web web.local
192.168.52.102  db db.local
192.168.52.103  automate automate.local
EOF

yum -y install ntp net-tools gcc gcc-c++ kernel-devel

#Setup NTP
systemctl enable --now ntpd

#Add Puppet Repo
rpm -Uvh https://yum.puppet.com/puppet7-release-el-7.noarch.rpm
