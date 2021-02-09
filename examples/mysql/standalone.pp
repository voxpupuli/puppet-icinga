class { '::icinga::repos':
  manage_epel => true,
}

class { '::icinga::server':
  ca                   => true,
  config_server        => true,
  global_zones         => [ 'global-templates', 'linux-commands', 'windows-commands' ],
}

class { '::icinga::ido':
  db_type         => 'mysql',
  db_host         => 'localhost',
  db_pass         => 'icinga2',
  manage_database => true,
}

class { '::icinga::web':
  backend_db_type => $icinga::ido::db_type,
  backend_db_host => $icinga::ido::db_host,
  backend_db_pass => $icinga::ido::db_pass,
  db_type         => 'mysql',
  db_host         => 'localhost',
  db_pass         => 'icingaweb2',
  manage_database => true,
  api_pass        => 'icingaweb2',
}
