# @summary
#   Setup a Icinga worker (aka satellite).
#
# @param ca_server
#   The CA to send the certificate request to.
#
# @param zone
#   Name of the Icinga zone.
#
# @param parent_zone
#   Name of the parent Icinga zone.
#
# @param parent_endpoints
#   Configures these endpoints of the parent zone.
#
# @param colocation_endpoints
#   When the zone includes more than one endpoint, set here the additional endpoint(s).
#   Icinga supports two endpoints per zone only.
#
# @param workers
#   All cascading worker zones with key 'endpoints' for endpoint objects.   
#
# @param global_zones
#   List of global zones to configure.
#
# @param logging_type
#   Switch the log target. On Windows `syslog` is ignored, `eventlog` on all other platforms.
#
# @param logging_level
#   Set the log level.
#
# @param run_web
#   Prepare to run Icinga Web 2 on the same machine. Manage a group `icingaweb2`
#   and add the Icinga user to this group.
#
# @param ssh_private_key
#   The private key to install.
#
# @param ssh_key_type
#   SSH key type.
#
# @param parent_export
#   Exports zone and endpoints to parent hosts if `icinga::config_server` is given.
#   Optional override endpoint parameters to export.
#
class icinga::worker (
  Stdlib::Host                       $ca_server,
  String[1]                          $zone,
  Enum['file', 'syslog', 'eventlog'] $logging_type,
  Icinga::LogLevel                   $logging_level,
  Hash[String[1], Hash]              $parent_endpoints,
  String[1]                          $parent_zone          = 'main',
  Hash[String[1], Hash]              $colocation_endpoints = {},
  Hash[String[1], Hash]              $workers              = {},
  Array[String[1]]                   $global_zones         = [],
  Boolean                            $run_web              = false,
  Optional[Icinga::Secret]           $ssh_private_key      = undef,
  Enum['ecdsa','ed25519','rsa']      $ssh_key_type         = rsa,
  Variant[Boolean, Icinga::Endpoint] $parent_export        = true,
) {
  # inject parent zone if no parent exists
  $_workers = $workers.reduce({}) |$memo, $worker| { $memo + { $worker[0] => { parent => $zone } + $worker[1] } }

  class { 'icinga':
    ca              => false,
    ca_server       => $ca_server,
    this_zone       => $zone,
    zones           => {
      'ZoneName'   => { 'endpoints' => { 'NodeName' => {} } + $colocation_endpoints, 'parent' => $parent_zone, },
      $parent_zone => { 'endpoints' => $parent_endpoints, },
    } + $_workers,
    logging_type    => $logging_type,
    logging_level   => $logging_level,
    ssh_key_type    => $ssh_key_type,
    ssh_private_key => $ssh_private_key,
    prepare_web     => $run_web,
  }

  include icinga2::feature::checker

  icinga2::object::zone { $global_zones:
    global => true,
    order  => 'zz',
  }

  #
  # autodiscover monitoring
  #
  $export = $icinga::config_server

  if $export {
    if $parent_export {
      $_obj = if $parent_export =~ Boolean {
        {}
      } else {
        $parent_export
      }

      @@icinga::helper::zone { $zone:
        parent => $parent_zone,
      }

      @@icinga::helper::endpoint { $icinga::cert_name:
        zone    => $zone,
        content => epp('icinga2/object.conf.epp', {
            'object_name' => $icinga::cert_name,
            'object_type' => 'Endpoint',
            'attrs'       => delete_undef_values({
                'host' => pick($icinga2::feature::api::bind_host, $facts['networking']['ip']),
                'port' => $icinga2::feature::api::bind_port,
            } + $_obj),
            'attrs_list'  => ['host', 'port', 'log_duration'],
        }),
      }
    }

    icinga::helper::objects { 'Worker Objects':
      export  => $export,
      objects => $icinga::objects,
      target  => "/etc/icinga2/zones.d/${parent_zone}/auto.conf",
    }
  }
}
