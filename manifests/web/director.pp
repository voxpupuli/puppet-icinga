# @summary
#   Setup Director module for Icinga Web 2
#
# @param [String] db_pass
#   Password to connect the database.
#
class icinga::web::director(
  String                                 $db_pass,
  String                                 $api_pass,
  String                                 $endpoint,
  Enum['mysql','pgsql']                  $db_type         = 'mysql',
  Stdlib::Host                           $db_host         = 'localhost',
  Optional[Stdlib::Port]                 $db_port         = undef,
  String                                 $db_name         = 'director',
  String                                 $db_user         = 'director',
  Boolean                                $manage_database = false,
  Stdlib::Host                           $api_host        = 'localhost',
  String                                 $api_user        = 'director',
) {

  unless $db_port {
    $_db_port = $db_type ? {
      'pgsql' => 5432,
      default => 3306,
    }
  } else {
    $_db_port = $db_port
  }

  #
  # Database
  #
  if $manage_database {
    class { '::icinga::web::director::database':
      db_type       => $db_type,
      db_name       => $db_name,
      db_user       => $db_user,
      db_pass       => $db_pass,
      web_instances => [ 'localhost' ],
      before        => Class['icingaweb2::module::director'],
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

  class { 'icingaweb2::module::director':
    install_method => 'package',
    db_type        => $db_type,
    db_host        => $_db_host,
    db_name        => $db_name,
    db_username    => $db_user,
    db_password    => $db_pass,
    import_schema  => true,
    kickstart      => true,
    endpoint       => $endpoint,
    api_host       => $api_host,
    api_username   => $api_user,
    api_password   => $api_pass,
    db_charset     => 'UTF8',
  }

}
