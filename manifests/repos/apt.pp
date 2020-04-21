# @summary
#   Manage repositories via `apt`.
# @api private
#
class icinga::repos::apt {

  assert_private()

  $repos   = $::icinga::repos::list
  $enabled = $::icinga::repos::enabled

  $configure_backports = $::icinga::repos::configure_backports

  include ::apt
  if $configure_backports {
    include ::apt::backports
    Apt::Source['backports'] -> Package <| |>
  }

  $repos.each |String $repo_name, Hash $repo_config| {
    apt::source { $repo_name:
      * =>  merge($repo_config, {
        ensure => $enabled[$repo_name] ? {
          true  => present,
          false => absent,
        }
      })
    }
    Apt::Source[$repo_name] -> Package <| |>
  }

}
