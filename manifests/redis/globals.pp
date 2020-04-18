# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include icinga::redis::globals
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
