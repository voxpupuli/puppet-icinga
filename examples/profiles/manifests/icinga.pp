# @summary
#   Example profile class to setup configure Icinga.
#
# @param type
#   What kind of Icinga role to setup.
#
class profile::icinga (
  Enum['agent', 'worker', 'server'] $type = 'agent',
) {
  case $type {
    'agent': {
      if $facts['kernel'] != 'windows' {
        include icinga::repos
      }
      include icinga::agent
    } # agent

    'worker': {
      include icinga::repos
      include icinga::worker
    } # worker

    'server': {
      class { 'icinga::repos':
        manage_extras => true,
      }

      include profile::icinga::server
    } # server

    default: {}
  }

  class { 'icinga::config':
    objects => {
      'Service' => profile::icinga::disks($icinga::cert_name),
    },
  }
}
