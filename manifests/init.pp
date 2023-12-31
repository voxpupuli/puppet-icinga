# @summary
#   Configures the Icinga 2 Core and the api feature.
#
# @api private
#
# @param ca
#   Enables a CA on this node.
#
# @param this_zone
#   Name of the Icinga zone.
#
# @param zones
#   All other zones.
#
# @param ca_server
#   The CA to send the certificate request to.
#
# @param ticket_salt
#   Set the constants `TicketSalt` if `ca` is set to `true`. Otherwise the set value is used
#   to authenticate the certificate request againt the CA on host `ca_server`.
#
# @param logging_type
#   Switch the log target. On Windows `syslog` is ignored, `eventlog` on all other platforms.
#
# @param logging_level
#   Set the log level.
#
# @param cert_name
#   The certificate name to set as constant NodeName.
#
# @param prepare_web
#   Prepare to run Icinga Web 2 on the same machine. Manage a group `icingaweb2`
#   and add the Icinga user to this group.
#
# @param confd
#   `conf.d` is the directory where Icinga 2 stores its object configuration by default. To enable it,
#   set this parameter to `true`. It's also possible to assign your own directory. This directory must be
#   managed outside of this module as file resource with tag icinga2::config::file.
#
class icinga (
  Boolean                              $ca,
  String                               $this_zone,
  Hash[String, Hash]                   $zones,
  Optional[Stdlib::Host]               $ca_server       = undef,
  Optional[Icinga::Secret]             $ticket_salt     = undef,
  Array[String]                        $extra_packages  = [],
  Enum['file', 'syslog', 'eventlog']   $logging_type    = 'file',
  Optional[Icinga::LogLevel]           $logging_level   = undef,
  String                               $cert_name       = $facts['networking']['fqdn'],
  Boolean                              $prepare_web     = false,
  Variant[Boolean, String]             $confd           = false,
) {
  assert_private()

  # CA uses const TicketSalt to set the ticket salt
  if $ca {
    if $ticket_salt {
      $_constants = { 'TicketSalt' => $ticket_salt, 'ZoneName' => $this_zone, 'NodeName' => $cert_name }
    } else {
      fail("Class[Icinga]: parameter 'ticket_salt' expects a String value if a CA is configured, got Undef")
    }
  } else {
    $_constants = { 'ZoneName' => $this_zone, 'NodeName' => $cert_name }
  }

  $manage_packages = $facts[os][family] ? {
    'redhat'  => false,
    'debian'  => false,
    'windows' => lookup('icinga2::manage_packages', undef, undef, true),
    'suse'    => false,
    default   => true,
  }

  class { 'icinga2':
    confd           => $confd,
    manage_packages => $manage_packages,
    constants       => lookup('icinga2::constants', undef, undef, {}) + $_constants,
    features        => [],
  }

  # switch logging between mainlog, syslog and eventlog
  if $facts['kernel'] != 'windows' {
    if $logging_type == 'file' {
      $_mainlog = 'present'
      $_syslog  = 'absent'
    } else {
      $_mainlog = 'absent'
      $_syslog  = 'present'
    }

    class { 'icinga2::feature::syslog':
      ensure   => $_syslog,
      severity => $logging_level,
    }
  } else {
    if $logging_type == 'file' {
      $_mainlog  = 'present'
      $_eventlog = 'absent'
    } else {
      $_mainlog  = 'absent'
      $_eventlog = 'present'
    }

    class { 'icinga2::feature::windowseventlog':
      ensure   => $_eventlog,
      severity => $logging_level,
    }
  }

  class { 'icinga2::feature::mainlog':
    ensure   => $_mainlog,
    severity => $logging_level,
  }

  case $facts['kernel'] {
    'linux': {
      $icinga_user    = $icinga2::globals::user
      $icinga_package = $icinga2::globals::package_name
      $icinga_service = $icinga2::globals::service_name

      case $facts['os']['family'] {
        'redhat': {
          package { ['nagios-common', $icinga_package] + $extra_packages:
            ensure => installed,
          }

          -> group { 'nagios':
            members => [$icinga_user],
          }
        }

        'debian': {
          package { [$icinga_package] + $extra_packages:
            ensure => installed,
          }
        }

        'suse': {
          package { [$icinga_package] + $extra_packages:
            ensure => installed,
          }
        }

        default: {
          fail("'Your operatingssystem ${::facts['os']['name']} is not supported'")
        }
      }

      if $prepare_web {
        Package['icinga2'] -> Exec['restarting icinga2'] -> Class['icinga2']

        group { 'icingaweb2':
          system  => true,
          members => $icinga_user,
        }

        ~> exec { 'restarting icinga2':
          path        => $facts['path'],
          command     => "service ${icinga_service} restart",
          onlyif      => "service ${icinga_service} status",
          refreshonly => true,
        }
      }
    } # Linux

    'windows': {
      $manage_repo = false

      if $logging_type != 'file' {
        fail('Only file is supported as logging_type on Windows')
      }
    }

    default: {
      fail("'Your operatingssystem ${facts[os][name]} is not supported'")
    }
  } # kernel

  if $ca {
    include icinga2::pki::ca

    class { 'icinga2::feature::api':
      pki             => 'none',
      accept_config   => true,
      accept_commands => true,
      ticket_salt     => 'TicketSalt',
      zones           => {},
      endpoints       => {},
    }
  } else {
    if $ca_server {
      class { 'icinga2::feature::api':
        accept_config   => true,
        accept_commands => true,
        ca_host         => $ca_server,
        ticket_salt     => $ticket_salt,
        zones           => {},
        endpoints       => {},
      }
    }
  }

  $zones.each |String $zone, Hash $zone_attrs| {
    $zone_attrs.each|String $attr, $value| {
      if $attr == 'endpoints' {
        $value.each |String $endpoint, Hash $endpoint_attrs| {
          icinga2::object::endpoint { $endpoint:
            * => $endpoint_attrs,
          }
        }
      } # endpoints
    }

    icinga2::object::zone { $zone:
      * => $zone_attrs + { 'endpoints' => keys($zone_attrs['endpoints']) },
    }
  }
}
