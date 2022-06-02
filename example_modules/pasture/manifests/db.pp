class pasture::db (
  $web_server = 'local',
  $db_listen = '*',
  $db_port = '5432',
  $db = 'pasturedb',
  $db_user = 'pasture',
  $db_pass = 'pasturepass',
){

  class { 'postgresql::server':
    listen_addresses => $db_listen,
    port => $db_port,
  }

  postgresql::server::db { $db: 
    user => $db_user,
    password => postgresql::postgresql_password($db_user, $db_pass),
  }

  postgresql::server::pg_hba_rule { 'allow web server to access pasture db':
    type => 'host',
    database => $db,
    user => $db_user,
    address => $web_server,
    auth_method => 'password',
  }
}
