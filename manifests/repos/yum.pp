# @summary
#   Manage repositories via `yum`.
#
# @api private
#
class icinga::repos::yum {
  assert_private()

  $repos   = $icinga::repos::list
  $managed = $icinga::repos::managed

  # EPEL package
  if !'epel' in keys($repos) and $managed['epel'] {
    warning("Repository EPEL isn't available on ${facts['os']['name']} ${facts['os']['release']['major']}.")
  }

  # PowerTools package
  if !'powertools' in keys($repos) and $managed['powertools'] {
    warning("Repository PowerTools isn't available on ${facts['os']['name']} ${facts['os']['release']['major']}.")
  }

  # fix issue 21, 33
  file { ['/etc/yum.repos.d/netways-plugins.repo', '/etc/yum.repos.d/netways-extras.repo']:
    ensure => 'absent',
  }

  $repos.each |String $repo_name, Hash $repo_config| {
    if $repo_name in keys($managed) and $managed[$repo_name] {
      Yumrepo[$repo_name] -> Package <| |>
      yumrepo { $repo_name:
        *       => $repo_config,
        require => File['/etc/yum.repos.d/netways-plugins.repo', '/etc/yum.repos.d/netways-extras.repo'],
      }
    }
  }
}
