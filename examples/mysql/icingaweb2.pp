class { 'icinga::repos':
  manage_epel   => true,
}

class { 'icinga::web':
  db_type            => 'mysql',
  db_host            => 'localhost',
  db_pass            => 'icingaweb2',
  default_admin_user => 'admin',
  default_admin_pass => 'admin',
  manage_database    => true,
}
