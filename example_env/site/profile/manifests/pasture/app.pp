class profile::pasture::app (
    String $server_pkg = 'webrick',
    Integer $port = 80,
    String $db_server = 'none',
    String $db = "none",
    String $db_user = 'none',
    String $db_pass = 'none',
    String $default_character = 'koala',
    String $default_message = "Welcome to ${facts['fqdn']}",
    String $pasture_config = '/etc/pasture_config.yaml'
){
  class { 'pasture':
    web_server_pkg  => $server_pkg,
    web_port => $port,
    db_server => $db_server,
    db => $db,
    db_user => $db_user,
    db_pass => $db_pass,
    default_message => $default_message,
    default_character => $default_character,
    pasture_config => $pasture_config,
  }
}
