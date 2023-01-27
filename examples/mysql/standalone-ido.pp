# Setting riquired for MySQL < 5.7 and MariaDB < 10.2
if $facts['os']['family'] == 'redhat' and Integer($fachts['os']['release']['major']) < 8 {
  class { 'mysql::server':
    override_options => {
      mysqld => {
        innodb_file_format    => 'barracuda',
        innodb_file_per_table => 1,
        innodb_large_prefix   => 1,
      },
    },
  }
}

class { 'icinga::repos':
  manage_epel   => true,
  manage_extras => true,
}

class { 'icinga::server':
  ca                => true,
  config_server     => true,
  global_zones      => ['global-templates', 'linux-commands', 'windows-commands'],
  web_api_pass      => 'icingaweb2',
  director_api_pass => 'director',
  run_web           => true,
}

class { 'icinga::ido':
  db_type         => 'mysql',
  db_pass         => 'icinga2',
  manage_database => true,
}

class { 'icinga::web':
  db_type            => 'mysql',
  db_pass            => 'icingaweb2',
  default_admin_user => 'admin',
  default_admin_pass => 'admin',
  manage_database    => true,
  api_pass           => $icinga::server::web_api_pass,
}

class { 'icinga::web::monitoring':
  db_type => $icinga::ido::db_type,
  db_host => $icinga::ido::db_host,
  db_pass => $icinga::ido::db_pass,
}

class { 'icinga::web::director':
  db_type         => 'mysql',
  db_pass         => 'director',
  manage_database => true,
  endpoint        => $facts['networking']['fqdn'],
  api_pass        => $icinga::server::director_api_pass,
}
