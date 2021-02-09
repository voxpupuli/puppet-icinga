# @summary
#   Configure IDO Backend.
#
# @param [String] db_pass
#   Password to connect the database.
#
# @param [Enum['mysql','pgsql']] db_type
#   What kind of database type to use.
#
# @param [Stdlib::Host] db_host
#   Database host to connect.
#
# @param [String] db_name
#   Name of the database.
#
# @param [String] db_user
#   Database user name.
#
# @param [Boolean] manage_database
#   Create database.
#
# @param [Boolean] enable_ha
#   Enable HA feature for database.
#
class icinga::ido(
  String                                 $db_pass,
  Enum['mysql','pgsql']                  $db_type         = 'mysql',
  Stdlib::Host                           $db_host         = 'localhost',
  String                                 $db_name         = 'icinga2',
  String                                 $db_user         = 'icinga2',
  Boolean                                $manage_database = false,
  Boolean                                $enable_ha       = false,
) {

  if $manage_database {
    class { '::icinga::ido::database':
      db_type       => $db_type,
      db_name       => $db_name,
      db_user       => $db_user,
      db_pass       => $db_pass,
      ido_instances => [ 'localhost' ],
      before        => Class["icinga2::feature::ido${db_type}"],
    }
   $_db_host = 'localhost'
  } else {
   if $db_type != 'pgsql' {
     include ::mysql::client
   } else {
     include ::postgresql::client
   }
   $_db_host = $db_host
  }

  if $::kernel == 'linux' {
    $ido_package_name = $db_type ? {
      'mysql' => $::icinga2::globals::ido_mysql_package_name,
      'pgsql' => $::icinga2::globals::ido_pgsql_package_name,
    }

    if $::osfamily == 'debian' {
      ensure_resources('file', { '/etc/dbconfig-common' => { ensure => directory, owner => 'root', group => 'root' } })
      file { "/etc/dbconfig-common/${ido_package_name}.conf":
        ensure  => file,
        content => "dbc_install='false'\ndbc_upgrade='false'\ndbc_remove='false'\n",
        mode    => '0600',
        before  => Package[$ido_package_name],
      }
    } # Debian

    package { $ido_package_name:
      ensure => installed,
      before => Class["icinga2::feature::ido${db_type}"],
    }
  } # Linux

  class { "::icinga2::feature::ido${db_type}":
    host          => $_db_host,
    database      => $db_name,
    user          => $db_user,
    password      => $db_pass,
    import_schema => true,
    enable_ha     => $enable_ha,
  }
  
}


class icinga::ido::database(
  Enum['mysql','pgsql']  $db_type,
  Array[Stdlib::Host]    $ido_instances,
  String                 $db_pass,
  String                 $db_name       = 'icinga2',
  String                 $db_user       = 'icinga2',
) {

  ::icinga::database { "$db_type-$db_name":
    db_type          => $db_type,
    db_name          => $db_name,
    db_user          => $db_user,
    db_pass          => $db_pass,
    access_instances => $ido_instances,
    mysql_privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'ALTER', 'INDEX', 'EXECUTE'],
  }

}
