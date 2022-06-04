class pasture (
  $web_server_pkg = 'webrick',
  $web_port  = 80,
  $db_server = 'none',
  $db_port = 5432,
  $db = 'none',
  $db_user = 'none',
  $db_pass = 'none',
  $default_character = 'dragon',
  $default_message = 'Hello, Coders!',
  $pasture_config = '/etc/pasture_config.yaml',
){
  # learn about the pasture code here:
  # https://github.com/puppetlabs/pltraining-pasture/blob/master/lib/pasture/api.rb

  include pasture::base
  
  package { 'pasture':
    ensure => present,
    provider => 'gem',
    before => [
      File[$pasture_config], 
      File['/etc/systemd/system/pasture.service'],
    ],
  }

  if $db == 'none' {
    $database = 'none'
  } else {
    $database = "postgres://$db_user:$db_pass@$db_server:$db_port/$db"
  }
  $pasture_config_params = {
    'web_server_pkg' => $web_server_pkg,
    'web_port' => $web_port,
    'database' => $database,
    'default_animal' => $default_character,
    'default_message' => $default_message,
  }

  file { $pasture_config:
    content => epp('pasture/pasture_config.yaml.epp', $pasture_config_params),
  }

  $pasture_svc_params = {
    'pasture_config' => $pasture_config,
  }
  file { '/etc/systemd/system/pasture.service':
    content => epp('pasture/pasture.service.epp', $pasture_svc_params),
  }

  service { 'pasture':
    ensure => running,
    subscribe => File[$pasture_config],
    require => File['/etc/systemd/system/pasture.service'],
  }
}
