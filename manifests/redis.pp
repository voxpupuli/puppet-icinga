# @summary icinga::redis
# Installs and configures the Icinga Redis server package.
#
# @example
#   require icinga::redis
#
class icinga::redis {

  require ::icinga::redis::globals

  $package_name = $::icinga::redis::globals::package_name
  $conf_dir     = $::icinga::redis::globals::conf_dir
  $log_dir      = $::icinga::redis::globals::log_dir
  $run_dir      = $::icinga::redis::globals::run_dir
  $work_dir     = $::icinga::redis::globals::work_dir
  $user         = $::icinga::redis::globals::user
  $group        = $::icinga::redis::globals::group

  class { 'redis':
    manage_repo     => false,
    package_name    => $package_name,
    config_dir      => $conf_dir,
    workdir         => $work_dir,
    log_dir         => $log_dir,
    default_install => false,
    ulimit          => 4094,
    config_owner    => $user,
    config_group    => $group,
    service_user    => $user,
    service_group   => $group,
    service_manage  => false,
  }

}
