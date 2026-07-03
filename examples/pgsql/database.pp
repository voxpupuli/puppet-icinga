class { 'postgresql::server':
  listen_addresses => '*',
}

class { 'icinga::db::database':
  icingadb_instances => ['192.168.5.13', '192.168.5.23'],
  db_type            => 'pgsql',
  db_pass            => 'icingadb',
}

class { 'icinga::web::database':
  web_instances => ['192.168.5.13', '192.168.5.23'],
  db_type       => 'pgsql',
  db_pass       => 'icingaweb2',
}
