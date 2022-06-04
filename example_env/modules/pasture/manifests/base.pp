class pasture::base {
  package { 'gem':
    ensure => present,
    before => Package['cowsay'],
  }

  package { 'epel-release':
    ensure => present,
    before => Package['rubygem-thin'],
  }

  package { 'ruby-devel':
    ensure => present,
  }

  package { 'postgresql-devel':
    ensure => present,
  }

  package { 'rubygem-thin':
    ensure => present,
  }

  package { 'cowsay':
    ensure => present,
    provider => 'gem',
  }

  if($pasture::web_server =='thin') {
    package { 'thin':
      ensure => present,
      provider => 'gem',
      require =>  Package['gem'],
    }  
  }
}
