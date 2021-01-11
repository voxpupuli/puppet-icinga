# icinga

![Icinga Logo](https://www.icinga.com/wp-content/uploads/2014/06/icinga_logo.png)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with icinga](#setup)
    * [What icinga affects](#what-icinga-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with icinga](#beginning-with-icinga)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference](#reference)
5. [Release notes](#release-notes)

## Description

This module provides the management of upstrem repositories that can use by the other Icinga modules and a base class to handle the Icinga Redis package.

## Setup

### What the Icinga Puppet module supports

* Involves the needed repositories to install icinga2, icingadb and icingaweb2:
 * The Icinga Project repository for the stages: stable, testing or nightly builds 
 * EPEL repository for RHEL simular platforms
 * Backports repository for Debian and Ubuntu
* The Class to install Icinga-Redis, a requirement for the IcingaDB module.

### Setup Requirements

This module supports:

* [puppet] >= 4.10 < 7.0.0

And requiers:

* [puppetlabs/stdlib] >= 5.0.0 < 7.0.0
    * If Puppet 6 is used a stdlib 5.1 or higher is required
* [puppetlabs/apt] >= 6.0.0 < 8.0.0
* [puppet/zypprepo] >= 2.2.1 < 4.0.0
* [puppetlabs/yumrepo_core] >= 1.0.0
    * If Puppet 6 is used

Soft dependencies to manage yourself:

* [puppet/redis] >= 4.2.1 < 7.0.0
    * If class `icinga::redis` is used

### Beginning with icinga

Add this declaration to your Puppetfile:
```
mod 'icinga',
  :git => 'https://github.com/icinga/puppet-icinga.git',
  :tag => 'v0.1.0'
```
Then run:
```
bolt puppetfile install
```

Or do a `git clone` by hand into your modules directory:
```
git clone https://github.com/icinga/puppet-icinga.git icinga
```
Change to `icinga` directory and check out your desired version:
```
cd icinga
git checkout v0.1.0
```

## Usage

By default the upstream Icinga repository for stable release are involved.
```
include ::icinga::repos
```
To setup the testing repository for release candidates use instead:
```
class { '::icinga::repos':
  manage_stable  => false,
  manage_testing => true,
}
```
Or the nightly builds:
```
class { '::icinga::repos':
  manage_stable  => false,
  manage_nightly => true,
}
```

Other possible needed repositories like EPEL on RHEL or the Backports on Debian can also be involved:
```
class { '::icinga::repos':
  manage_epel         => true,
  configure_backports => true,
}
```
The prefix `configure` means that the repository is not manageable by the module. But backports can be configured by the class apt::backports, that is used by this module.
  
To change to a non upstream repository, e.g. a local mirror, the repos can be customized via hiera. The module does a deep merge lookup for a hash named `icinga::repos`. Allowed keys are:

* icinga-stable-release
* icinga-testing-builds
* icinga-snapshot-builds
* epel (only on RHEL Enterprise platforms)

An example to configure a local mirror of the stable release:
```
---
icinga::repos:
  icinga-stable-release:
    baseurl: 'http://repo.example.com/icinga/epel/$releasever/release/'
    gpgkey: http://repo.example.com/icinga/icinga.key
```
IMPORTANT: The configuration hash depends on the platform an requires one of the following resources:

* apt::source (Debian family, https://forge.puppet.com/puppetlabs/apt)
* yumrepo (RedHat family, https://forge.puppet.com/puppetlabs/yumrepo_core)
* zypprepo (SUSE, https://forge.puppet.com/puppet/zypprepo)

Also the Backports repo on Debian can be configured like the apt class of course, see https://forge.puppet.com/puppetlabs/apt to configure the class `apt::backports` via Hiera.

As an example, how you configure backpaorts on a debian squeeze. For squeeze the repository is already moved to the unsupported archive:

```
---
apt::confs:
  no-check-valid-until:
    content: 'Acquire::Check-Valid-Until no;'
    priority: 99
    notify_update: true
apt::backports::location: 'http://archive.debian.org/debian'
```


## Reference

See [REFERENCE.md](https://github.com/Icinga/puppet-icinga/blob/master/REFERENCE.md)

## Release Notes

This code is a very early release and may still be subject to significant changes.
