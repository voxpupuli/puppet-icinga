# @summary
#   Manage repositories via `yum`.
#
# @api private
#
class icinga::repos::yum {

  assert_private()

  $repos   = $::icinga::repos::list
  $managed = $::icinga::repos::managed

  # EPEL isn't supported
  if !'epel' in keys($repos) and $managed['epel'] {
    warning("Repository EPEL isn't available on ${facts['os']['name']} ${facts['os']['release']['major']}.")
  }

  $repos.each |String $repo_name, Hash $repo_config| {
    if $repo_name in keys($managed) and $managed[$repo_name] {
      yumrepo { $repo_name:
        * =>  $repo_config,
      }
      Yumrepo[$repo_name] -> Package <| |>
    }
  }

}

