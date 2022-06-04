class profile::pasture::db (
    String $allowed_ip,
    String $listen,
    Integer $port,
    String $db,
    String $user,
    String $pass,
){
  class { 'pasture::db':
    allowed_ip => $allowed_ip,
    db_listen => $listen,
    db_port => $port,
    db => $db,
    db_user => $user,
    db_pass => $pass,
  }
}
