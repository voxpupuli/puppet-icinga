# @summary icinga::repos
#
# This class manages the stages stable, testing and snapshot of packages.icinga.com repository
# based on the operating system platform.
# Windows is not supported, as the Icinga Project does not offer a chocolate repository.
#
# @manage_stable
#   Manage the Icinga stable repository. Disabled by setting to 'false'. Defaults to 'true'.
#
# @manage_testing
#   Manage the Icinga testing repository to get access to release candidates.
#   Enabled by setting to 'true'. Defaults to 'false'.
#
# @manage_nightly
#   Manage the Icinga snapshot repository to get access to nightly snapshots.
#   Enabled by setting to 'true'. Defaults to 'false'.
#
# @configure_backports
#   Enables the backports repository permanently. Has only an effect on plattforms
#   simular to Debian. Defaults to 'false'.
#
# @manage_epel
#   Manage the EPEL (Extra Packages Enterprise Linux) repository that is needed for some package
#   like newer Boost libraries. Has only an effect on plattforms simular to RedHat. Defaults to 'false'.
#
# @configure_scl
#   Enables SCL (Software Collection Linux) repositories. Has only an effect on CentOS
#   or Scientific platforms. Defaults to 'false'.
#   
#
# @example
#   include icinga::repos
#
class icinga::repos(
  Boolean $manage_stable       = true,
  Boolean $manage_testing      = false,
  Boolean $manage_nightly      = false,
  Boolean $configure_backports = false,
  Boolean $manage_epel         = false,
  Boolean $configure_scl       = false,
) {

  $list    =  lookup('icinga::repos', Hash, 'deep', {})
  $enabled = {
    icinga-stable-release  => $manage_stable,
    icinga-testing-builds  => $manage_testing,
    icinga-snapshot-builds => $manage_nightly,
  }

  case $::facts['os']['family'] {

    'redhat': {
      contain ::icinga::repos::yum
    }

    'debian': {
      contain ::icinga::repos::apt
    }

    'suse': {
      contain ::icinga::repos::zypper
    }

    'windows': {
      warning("The Icinga Project doesn't offer chocolaty packages at the moment.")
    }

    default: {
      fail('Your plattform is not supported to manage repositories.')
    }

  } # osfamily

}
