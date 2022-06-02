node db.local {
  include nixmotd
  include class { 'pasture::db':
    web_server => '192.168.52.0/24',
    db_listen => '*',
    db_port => 5432,
    db => 'pasturedb',
    db_user => 'pasture',
    db_pass => 'pasturepass',
  }
}
