# @summary
#   Configures the Icinga 2 Core and the api feature.
#
# @api private
#
# @param [Boolean] ca
#   Enables a CA on this node.
#
# @param [String] ticket_salt
#   Set the constants `TicketSalt` if `ca` is set to `true`. Otherwise the set value is used
#   to authenticate the certificate request againt the CA on host `ca_server`.
#
# @param [String] this_zone
#   Name of the Icinga zone.
#
# @param [String] zones
#   All other zones.
#
# @param [Enum['dsa','ecdsa','ed25519','rsa']] ssh_key_type
#   SSH key type.
#
# @param [Optional[String]] ssh_private_key
#   The private key to install.
#
# @param [Optional[String]] ssh_public_key
#   The public key to install.
#
# @param [Optional[Stdlib::Host]] ca_server
#   The CA to send the certificate request to.
#
class icinga(
  Boolean                              $ca,
  String                               $ticket_salt,
  String                               $this_zone,
  Hash[String, Hash]                   $zones,
  Enum['dsa','ecdsa','ed25519','rsa']  $ssh_key_type    = 'rsa',
  Optional[String]                     $ssh_private_key = undef,
  Optional[String]                     $ssh_pub_key     = undef,
  Optional[Stdlib::Host]               $ca_server       = undef,
) {

  assert_private()

  # CA uses const TicketSalt to set the ticket salt
  if $ca {
    $_constants = { 'TicketSalt' => $ticket_salt, 'ZoneName' => $this_zone }
  } else {
    $_constants = { 'ZoneName' => $this_zone }
  }

  $manage_package = $facts[os][family] ? {
    'redhat' => false,
    'debian' => false,
    default  => true,
  }

  class { '::icinga2':
    confd          => false,
    manage_package => $manage_package,
    constants      => lookup('icinga2::constants', undef, undef, {}) + $_constants
  }

  case $::kernel {
    'linux': {
      $icinga_user    = $::icinga2::globals::user
      $icinga_group   = $::icinga2::globals::group
      $icinga_package = $::icinga2::globals::package_name
      $icinga_home    = $::icinga2::globals::spool_dir

      if $ssh_pub_key {
        $icinga_shell = '/bin/bash'
      } else {
        $icinga_shell = '/sbin/nologin'
      }

      case $::osfamily {
        'redhat': {
          package { [ 'nagios-common', $icinga_package ]:
            ensure => installed,
            before => User[$icinga_user],
          }

          user { $icinga_user:
            ensure => present,
            shell  => $icinga_shell,
            groups => [ 'nagios' ],
            before => Class['icinga2'],
          }
        } # RedHat

        'debian': {
          package { ['icinga2']:
            ensure => installed,
            before => User['nagios'],
          }

          user { 'nagios':
            ensure => present,
            shell  => $icinga_shell,
            before => Class['icinga2'],
          }
        } # Debian

        default: {
          fail("'Your operatingssystem ${::facts[os][name]} is not supported'")
        }
      } # osfamily

      if $ssh_pub_key {
        ssh_authorized_key { "${icinga_user}@${::fqdn}":
          ensure  => present,
          user    => $icinga_user,
          key     => $ssh_pub_key,
          type    => $ssh_key_type,
        }
      } # pubkey

      if $ssh_private_key {
        file { 
          default:
            ensure => file,
            owner  => $icinga_user,
            group  => $icinga_group;
          ["${icinga_home}/.ssh", "${icinga_home}/.ssh/controlmasters"]:
            ensure => directory,
            mode   => '0700';
          "${icinga_home}/.ssh/id_${ssh_key_type}":
            mode    => '0600',
            content => $ssh_private_key;
          "${icinga_home}/.ssh/config":
            content => "Host *\n  StrictHostKeyChecking no\n  ControlPath ${icinga_home}/.ssh/controlmasters/%r@%h:%p.socket\n  ControlMaster auto\n  ControlPersist 5m";
        }
      } # privkey
    } # Linux

    'windows': {
      $manage_package = true
      $manage_repo    = false
    }

    default: {
      fail("'Your operatingssystem ${::facts[os][name]} is not supported'")
    }
  } # kernel

  
  if $ca {
    include ::icinga2::pki::ca

    class { '::icinga2::feature::api':
      pki             => 'none',
      accept_config   => true,
      accept_commands => true,
      ticket_salt     => 'TicketSalt',
      zones           => {},
      endpoints       => {},
    }
  } else {
    if $ca_server {
      class { '::icinga2::feature::api':
        pki             => 'icinga2',
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
          ::icinga2::object::endpoint { $endpoint:
            * => $endpoint_attrs,
          }
        }
      } # endpoints
    }
    ::icinga2::object::zone { $zone:
      * => $zone_attrs + { 'endpoints' => keys($zone_attrs['endpoints']) }
    }
  }

}
