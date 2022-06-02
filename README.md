# Puppet Dev Environment
Multi VM development environment for Puppet testing using VirtualBox

Puppetserver will be configured to autosign CA cert requests for *.local machines, and agents in this Vagrantfile will be registered with the puppet.local server.

TODO
- PuppetDB
- Inital puppet modules


# VMs
- puppet server
- web server (puppet agent)
- DB server (puppet agent) 
- automation server (puppet agent)

# Login and Vagrant Commands
Username and password are "vagrant". Of coruse, as this is Vagrant, the usual Vagrant commands are expected to be used from the host:

```
vagrant ssh puppet
vagrant ssh web
vagrant ssh db
...
```

The vagrant and root users on the puppet.local server have their ssh keys (generated at run time)added to the authorized_keys on the other boxes (copied over via the /vagrant/puppet_provision directory).

Bolt commands from puppet.local to the others as the vagrant or root users will work.
Example:
```
bolt command run 'puppet agent -t' -t web.local --run-as root
```

# Network Layout
Each VM will have the default NAT eth0 that vagrant requires, along with a 2nd internal network interface

The NAT interface will of course be set via DHCP. 
Thet IntNet interfaces will be hardcoded. The IPs are added to the hosts files via the common.sh script

Example:
````
192.168.52.100  puppet.local
192.168.52.101  web.local
192.168.52.102  db.local
192.168.52.103  automate.local
````


# Vagrant BOX Configuration
Built and tested with Centos7 base box from 
https://github.com/drakoswraith/centos7_virtualboxiso_packer

By default, this vagrant file will look for an environment variable to locate the base box, and load the box file packer_centos7_virtualbox.box within that location.
Variable: VAGRANT_BOX_DIR
Format: URL

Windows example value:
````
PS C:\> $env:VAGRANT_BOX_DIR
file:///D:/sysimages/boxes

PS C:\> dir d:\sysimages\boxes


    Directory: D:\sysimages\boxes


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         5/16/2022   5:03 PM      635295232 packer_centos7_virtualbox.box
````

# Vagrant Modules
Currently, vagrant will create a symbolic link between /vagrant/modules (if it exists) to the production environment directory on the puppet.local server. This allows then edditing the manifests for the nodes to assign the modules.
```
ln -s /vagrant/modules /etc/puppetlabs/code/environments/production/
```

This is still under construction for the best way to do it...

Currently the manifests directory is not being linked to avoid immediately assigning nodes modules. 

My general expecetation is then other git projects (per modules) can be added in the host modules directory for a clear project structure.

I still have to work through all that, but the intial step is in place and easy to use.