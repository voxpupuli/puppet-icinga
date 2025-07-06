# @summary
#   Example profile class to setup an Icinga server.
#
# @param db_type
#   Which DBMS is to use.
#
class profile::icinga::server (
  Enum['mysql', 'pgsql'] $db_type = 'pgsql',
) {
  assert_private()

  class { 'icinga::server':
    ca            => true,
    config_server => true,
    web_api_pass  => Sensitive('icingaweb2'),
    run_web       => true,
  }

  class { 'icinga::db':
    db_type         => $db_type,
    db_pass         => Sensitive('icingadb'),
    manage_database => true,
  }

  class { 'icinga::web':
    db_type            => $db_type,
    db_pass            => Sensitive('icingaweb2'),
    default_admin_user => 'admin',
    default_admin_pass => Sensitive('admin'),
    manage_database    => true,
    api_pass           => $icinga::server::web_api_pass,
  }

  class { 'icinga::web::icingadb':
    db_type => $db_type,
    db_pass => $icinga::db::db_pass,
  }
}
