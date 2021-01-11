# @summary
#   Manage repositories via `apt`.
#
# @api private
#
class icinga::repos::apt {

  assert_private()

  $repos   = $::icinga::repos::list
  $managed = $::icinga::repos::managed

  $configure_backports = $::icinga::repos::configure_backports

  include ::apt
  if $configure_backports {
    include ::apt::backports
    Apt::Source['backports'] -> Package <| |>
  }

  $repos.each |String $repo_name, Hash $repo_config| {
    if $managed[$repo_name] {
      apt::source { $repo_name:
        * =>  merge({ ensure => present }, $repo_config),
      }
      Apt::Source[$repo_name] -> Package <| |>
    }
  }

}
