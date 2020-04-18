class icinga::repos::zypper {

  assert_private()

  $repos   = $::icinga::repos::list

  $repos.each |String $repo_name, Hash $repo_config| {
    if $repo_name in keys($_enabled) {
      if $repo_config['proxy'] {
        $_proxy = "--httpproxy ${repo_config['proxy']}"
      } else {
        $_proxy = undef
      }

      exec { "import ${repo_name} gpg key":
        path      => '/bin:/usr/bin:/sbin:/usr/sbin',
        command   => "rpm ${_proxy} --import ${repo_config['gpgkey']}",
        unless    => 'rpm -q gpg-pubkey-34410682',
        logoutput => 'on_failure',
      }

      -> zypprepo { $repo_name:
        * => merge(delete($repo_config, 'proxy'), { enabled => $_enabled[$repo_name] }),
      }

      -> file_line { "add proxy settings to ${repo_name}":
        path => "/etc/zypp/repos.d/${repo_name}.repo",
        line => "proxy=${repo_config['proxy']}",
      }
    }
  }

}

