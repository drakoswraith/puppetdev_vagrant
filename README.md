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

# Login 
Username and password are "vagrant"


# Network Layout
Each VM will have the default NAT eth0 that vagrant requires, along with a 2nd internal network interface

The NAT interface will of course be set via DHCP. 
Thet IntNet interfaces will be hardcoded. The IPs are added to the hosts files via the common.sh script

Example:
````
192.168.50.100  puppet.local
192.168.50.101  web.local
192.168.50.102  db.local
192.168.50.103  automate.local
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
