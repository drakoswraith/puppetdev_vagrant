class puppet_local_fw::puppetserver {
  firewall { '099 allow ssh':
    dport  => 22,
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '100 allow http and https access':
    dport  => [80, 443],
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '101 allow puppetserver traffic':
    dport  => 8140,
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '102 allow puppetdb traffic':
    dport  => 8080,
    proto  => 'tcp',
    action => 'accept',
  }
}
