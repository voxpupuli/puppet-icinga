# @summary icinga::repos
#
# This class manages the stages stable, testing and snapshot of packages.icinga.com repository
# based on the operating system platform.
# Windows is not supported, as the Icinga Project does not offer a chocolate repository.
#
# @manage_release
#
# @manage_testing
#
# @manage_snapshot
#
# @configure_backports
#
# @manage_epel
#
# @configure_scl
#
# @example
#   include icinga::repos
#
class icinga::repos(
  Boolean $manage_release      = true,
  Boolean $manage_testing      = false,
  Boolean $manage_snapshot     = false,
  Boolean $configure_backports = false,
  Boolean $manage_epel         = false,
  Boolean $configure_scl       = false,
) {

  $list    =  lookup('icinga::repos', Hash, 'deep', {})
  $enabled = {
    icinga-stable-release  => $manage_release,
    icinga-testing-builds  => $manage_testing,
    icinga-snapshot-builds => $manage_snapshot,
  }

  case $::facts['os']['family'] {

    'redhat': {
      contain ::icinga::repos::yum
    }

    'debian': {
      contain ::icinga::repos::apt
    }

    'windows': {
      warning("The Icinga Project doesn't offer chocolaty packages at the moment.")
    }

    default: {
      fail('Your plattform is not supported to manage repositories.')
    }

  } # osfamily

}
