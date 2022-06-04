class funwithfacts {
  $os_family = $facts['os']['family']
  notify { "OS Family: ${os_family}": }
  notify { "Disk info: ${facts['disk']}": }

  each ($facts['networking']['interfaces']) | $nic, $nic_props | {
    notify {"Network Interface ${nic}: ${nic_props['ip']}": }
  }
}
