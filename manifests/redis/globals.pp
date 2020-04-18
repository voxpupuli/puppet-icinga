# @summary icinga::redis::globals
#
# This class loads the default parameters by doing a hiera lookup.
#
# NOTE: This parameters depend on the os plattform. Changes maybe will
#       break the functional capability of the supported plattforms and versions.
#       Please only do changes when you know what you're doing.
#
#
class icinga::redis::globals(
  String                 $package_name,
  Stdlib::Absolutepath   $conf_dir,
  Stdlib::Absolutepath   $log_dir,
  Stdlib::Absolutepath   $run_dir,
  Stdlib::Absolutepath   $work_dir,
  String                 $user,
  String                 $group,
) {

}
