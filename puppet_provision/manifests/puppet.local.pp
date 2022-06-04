node 'puppet.local' {
  Firewall {
    before  => Class['puppet_local_fw::post'],
    require => Class['puppet_local_fw::pre'],
  }
  class { ['puppet_local_fw::pre', 'puppet_local_fw::puppetserver', 'puppet_local_fw::post']: }
  class { 'firewall': }
  
  resources { 'firewall':
    purge => true,
  }

  class { 'puppetdb':
    listen_address => '0.0.0.0',
    manage_firewall => false,
    java_args => {'-Xmx' => '512m', '-Xms' => '512m' },
  }
  class { 'puppetdb::master::config': }
}
