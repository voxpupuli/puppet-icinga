# @summary
#   Manage repositories via `yum`.
# @api private
#
class icinga::repos::yum {

  assert_private()

  $repos   = $::icinga::repos::list
  $enabled = $::icinga::repos::enabled

  $manage_epel = $::icinga::repos::manage_epel
  $manage_scl  = $::icinga::repos::manage_scl

  # EPEL package
  if 'epel' in keys($repos) {
    ensure_packages('epel-release', { before => Yumrepo['epel'] })
  } else {
    if $manage_epel {
      warning("Repository EPEL isn't available on ${facts['os']['name']} ${facts['os']['release']['major']}.")
    }
  }

  # SCL package
  if 'centos-sclo-sclo' in keys($repos) and 'centos-sclo-rh' in keys($repos) {
    ensure_packages('centos-release-scl', { before => Yumrepo['centos-sclo-sclo', 'centos-sclo-rh'] })
  } else {
    if $manage_scl {
      warning("Repository SCL isn't available on ${facts['os']['name']} ${facts['os']['release']['major']}.")
    }
  }

  $repos.each |String $repo_name, Hash $repo_config| {
    if $repo_name in keys($enabled) {
      yumrepo { $repo_name:
        * =>  merge($repo_config, { enabled => Integer($enabled[$repo_name]) })
      }
    }
    Yumrepo[$repo_name] -> Package <| title != 'epel-release' and title != 'centos-release-scl' |>
  }

}

