class icinga::ca(
) {

  include ::icinga2::pki::ca

  class { '::icinga2::feature::api':
    pki             => 'none',
    accept_commands => true,
  }

}
