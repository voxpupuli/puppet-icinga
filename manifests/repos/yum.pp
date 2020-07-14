# @summary
#   Manage repositories via `yum`.
# @api private
#
class icinga::repos::yum {

  assert_private()

  $repos   = $::icinga::repos::list
  $enabled = $::icinga::repos::enabled

  $manage_epel = $::icinga::repos::manage_epel

  # EPEL package
  if !'epel' in keys($repos) and $manage_epel {
    warning("Repository EPEL isn't available on ${facts['os']['name']} ${facts['os']['release']['major']}.")
  }

  $repos.each |String $repo_name, Hash $repo_config| {
    if $repo_name in keys($enabled) {
      yumrepo { $repo_name:
        * =>  merge($repo_config, { enabled => Integer($enabled[$repo_name]) })
      }
    }
    Yumrepo[$repo_name] -> Package <| |>
  }

}

