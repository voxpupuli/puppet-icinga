# @summary
#   Manage repositories via `yum`.
# @api private
#
class icinga::repos::yum {

  assert_private()

  $repos   = $::icinga::repos::list
  $enabled = $::icinga::repos::enabled

  $manage_epel   = $::icinga::repos::manage_epel
  $configure_scl = $::icinga::repos::configure_scl

  if $facts['os']['name'] in ['CentOS', 'Scientific', 'RedHat', 'OracleLinux'] {
    $_enabled = merge($enabled, { epel => $manage_epel })
  } else {
    $_enabled = $enabled
  }

  $repos.each |String $repo_name, Hash $repo_config| {
    if $repo_name in keys($_enabled) {
      yumrepo { $repo_name:
        * =>  merge($repo_config, { enabled => $_enabled[$repo_name] })
      }
    }
    Yumrepo[$repo_name] -> Package <| |>
  }

  if $configure_scl and $facts['os']['name'] in ['CentOS', 'Scientific'] {
    ensure_packages('centos-release-scl')
  }

}

