# Puppet Dev Environment
Multi VM development environment for Puppet testing using VirtualBox

puppet.local server will have puppetserver and puppetdb installed on it.
Puppetserver will be configured to autosign CA cert requests for *.local machines, and agents in this Vagrantfile will be registered with the puppet.local server.

PuppetDB configuraiton and basic firewall rules are applyed using the puppetlabs-puppetdb and puppetdb-firewall modules.
These are applied using a manually applied manifest and module under puppet_provision, which are copied to the production environement code folder and then "puppet apply" used.

The puppet.local server does not have the agent service enabled by default.

# VMs
- puppet server
- web server (puppet agent)
- DB server (puppet agent) 
- automation server (puppet agent) (...future)

# Login and Vagrant Commands
Username and password are "vagrant". Of coruse, as this is Vagrant, the usual Vagrant commands are expected to be used from the host:

```
vagrant ssh puppet
vagrant ssh web
vagrant ssh db
...
```

The vagrant and root users on the puppet.local server have their ssh keys (generated at run time) added to the authorized_keys on the other boxes (copied over via the /vagrant/puppet_provision directory).

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

## Port forwarding
TCP 22 for SSH is forwarded to 52n22 where "n" is the VM number, puppet.local:8080 is forwarded to localhost:52080 on the host machine for connecting to puppetdb.
```
localhost:52080 => puppet.local:8080

localhost:52022 => puppet.local:22
localhost:52122 => web.local:22
localhost:52222 => app.local:22
```


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

# Vagrant Example Modules
The project contains some example modules. These will not be deployed by default.
To cause them to be deployed, set the environment variable PDV_CONFIGEXAMPLES to 'true'

```
PS > $env:PDV_CONFIGEXAMPLES
true
```

When set to true, a new environment "example" will be setup, and the agents added to this.
Most of the files and folders under example_env folder will be synced by Vagrant to the puppet code folder under:
```
/etc/puppetlabs/code/environments/example/
```

The vagrant synced_folder commands are set so that other modules installed via dependencies and such will not replicate back to the local source folder. So, only the specific example_env/modules/ direcfties are synced.

The web and db servers will then have the Pasture app deployed with a PostgreSQL backend.
This is done via the roles and profiles pattern with a very basic hiera data lookup.

You will likely want ot force the agent runs to speed up application of the configurations:
```
bolt command run 'puppet agent -t' --run-as root -t web.local,db.local
```

## Pasture Web App Documentation
The Pasture web app's code is here: 
https://github.com/puppetlabs/pltraining-pasture/blob/master/lib/pasture/api.rb

Example commands:
```
# get the default saying
curl web.local:80/api/v1/cowsay

# Add some sayings to the DB
curl -X POST 'web.local:80/api/v1/cowsay/sayings?message=Vist%20Drakos%20Wraith%20GitHub%20today!'
curl -X POST 'web.local:80/api/v1/cowsay/sayings?message=Big%20Money'
curl -X POST 'web.local:80/api/v1/cowsay/sayings?message=Puppet%20Examples'

# Check the sayings
curl web.local:80/api/v1/cowsay/sayings
curl web.local:80/api/v1/cowsay/sayings/1
curl web.local:80/api/v1/cowsay/sayings/2
curl web.local:80/api/v1/cowsay/sayings/3

# Use custom character or message
curl 'web.local:80/api/v1/cowsay?character=dragon'
curl 'web.local:80/api/v1/cowsay?character=dragon&message=Hello,World!'
```
