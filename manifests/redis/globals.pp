# @summary
# This class loads the default parameters by doing a hiera lookup.
#
# @note
#
# This parameters depend on the os plattform. Changes maybe will break the functional
# capability of the supported plattforms and versions. Please only do changes when you
# know what you're doing.
#
# @param [String] package_name
#   The package name of Icinga Redis.
#
# @param [Stdlib::Absolutepath] redis_bin
#   Path to the redis binary.
# 
# @param [Stdlib::Absolutepath] conf_dir
#   Path to the directory in which the main configuration files reside.
# 
# @param [Stdlib::Absolutepath] log_dir
#   Path to the directory in which the log files reside.
# 
# @param [Stdlib::Absolutepath] run_dir
#   Location to store pid files.
# 
# @param [Stdlib::Absolutepath] work_dir
#   Path to the base working directory.
# 
# @param [String] user
#   User who ownes the config files.
#
# @param [String] group
#   Group to which the files belong.
#
# @api private
#
class icinga::redis::globals(
  String                 $package_name,
  Stdlib::Absolutepath   $redis_bin,
  Stdlib::Absolutepath   $conf_dir,
  Stdlib::Absolutepath   $log_dir,
  Stdlib::Absolutepath   $run_dir,
  Stdlib::Absolutepath   $work_dir,
  String                 $user,
  String                 $group,
) {

  unless $::facts['os']['name'] in [ 'redhat', 'centos', 'debian', 'ubuntu' ] {
    fail("Your platform ${::facts['os']['name']} is not supported.")
  }
}
