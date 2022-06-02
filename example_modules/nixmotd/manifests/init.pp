class nixmotd {
  file { '/etc/motd':
    content => epp('nixmotd/motd.epp')
  }
}
