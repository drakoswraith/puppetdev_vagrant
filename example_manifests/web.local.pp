# https://puppet.com/docs/puppet/7/lang_node_definitions.html

node 'web.local' {
  include nixmotd
  include class { 'pasture':
    web_server_pkg  => 'thin',
    web_port => 80,
    db_server => 'db.local',
    db => 'pasturedb',
    db_user => 'pasture',
    db_pass => 'pasturepass',
    default_message => 'Happy Parameters!',
    default_character => 'cow',
  }
}
