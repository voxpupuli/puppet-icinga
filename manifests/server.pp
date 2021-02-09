# @summary
#   Setup a Icinga server.
#
# @param [Boolean] ca
#   Enables a CA on this node.
#
# @param [Boolean] config_server
#   Enables that this node is the central configuration server.
#
# @param [String] zone
#   Name of the Icinga zone.
#
# @param [Hash[String,Hash]] colocation_endpoints
#   When the zone includes more than one endpoint, set here the additional endpoint(s).
#   Icinga supports two endpoints per zone only.
#
# @param [Array[String]] global_zones
#   List of global zones to configure.
#
# @param [Optional[Stdlib::Host]] ca_server
#   The CA to send the certificate request to.
#
# @param [Optional[String]] ticket_salt
#   Set an alternate ticket salt to icinga::ticket_salt from Hiera.
#
# @param [Optional[String]] web_api_pass
#   Icinga API password for user icingaweb2.
#
class icinga::server(
  Boolean                 $ca                   = false,
  Boolean                 $config_server        = false,
  String                  $zone                 = 'main',
  Hash[String,Hash]       $colocation_endpoints = {},
  Array[String]           $global_zones         = [],
  Optional[Stdlib::Host]  $ca_server            = undef,
  Optional[String]        $ticket_salt          = undef,
  Optional[String]        $web_api_pass         = undef,
) {

  if empty($colocation_endpoints) {
    $_ca            = true
    $_config_server = true
  } else {
    if !$ca and !$ca_server {
      fail('Class[Icinga::Server]: expects a value for parameter \'ca_server\'')
    }
    $_ca            = $ca
    $_config_server = $config_server
  }

  class { '::icinga':
    ca          => $_ca,
    ca_server   => $ca_server,
    this_zone   => $zone,
    zones       => {
      'ZoneName' => { 'endpoints' => { 'NodeName' => {}} + $colocation_endpoints },
    },
    ticket_salt  => $ticket_salt,
  }

  ::icinga2::object::zone { $global_zones:
    global => true,
  }
  
  if $_config_server {
    ($global_zones + $zone).each |String $dir| {
      file { "${::icinga2::globals::conf_dir}/zones.d/${dir}":
        ensure => directory,
        tag    => 'icinga2::config::file',
        owner  => $::icinga2::globals::user,
        group  => $::icinga2::globals::group,
        mode   => '0750',
      }
    }
  } else {
    file { "${::icinga2::globals::conf_dir}/zones.d":
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true,
    }
  }

  if $_config_server {
    ::icinga2::object::apiuser { 'icingaweb2':
      password    => $web_api_pass,
      permissions => [ 'status/query', 'actions/*', 'objects/modify/*', 'objects/query/*' ],
      target      => "/etc/icinga2/zones.d/${zone}/api-users.conf",
    }
  }

}
