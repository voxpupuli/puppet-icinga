# Change Log

## [v3.2.1](https://github.com/icinga/puppet-icinga/tree/v3.2.1) (2023-04-15)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v3.2.0...v3.2.1)

**Fixed bugs:**

- Fix db\_charset \(UTF8\) for the web-icingadb resource [\#86](https://github.com/Icinga/puppet-icinga/pull/86) ([lbetz](https://github.com/lbetz))

## [v3.2.0](https://github.com/icinga/puppet-icinga/tree/v3.2.0) (2023-03-10)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v3.1.1...v3.2.0)

**Implemented enhancements:**

- Install icingaweb2 model pdfexport by default [\#85](https://github.com/Icinga/puppet-icinga/pull/85) ([lbetz](https://github.com/lbetz))
- Add additional Apache vhost support, add apache module proxy\_http [\#84](https://github.com/Icinga/puppet-icinga/pull/84) ([lbetz](https://github.com/lbetz))

**Fixed bugs:**

- Remove handling of PHP extensions [\#83](https://github.com/Icinga/puppet-icinga/pull/83) ([lbetz](https://github.com/lbetz))

## [v3.1.1](https://github.com/icinga/puppet-icinga/tree/v3.1.1) (2023-03-05)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v3.1.0...v3.1.1)

**Fixed bugs:**

- Install citext extension via contrib class [\#82](https://github.com/Icinga/puppet-icinga/pull/82) ([lbetz](https://github.com/lbetz))

## [v3.1.0](https://github.com/icinga/puppet-icinga/tree/v3.1.0) (2023-03-05)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v3.0.1...v3.1.0)

**Implemented enhancements:**

- Add classes to manage idoreports [\#47](https://github.com/Icinga/puppet-icinga/issues/47)
- Add support for reporting [\#81](https://github.com/Icinga/puppet-icinga/pull/81) ([lbetz](https://github.com/lbetz))
- Add warning for CRB on unsupported os [\#77](https://github.com/Icinga/puppet-icinga/pull/77) ([lbetz](https://github.com/lbetz))

**Fixed bugs:**

- Turn on backports for Debian Buster by default  [\#79](https://github.com/Icinga/puppet-icinga/issues/79)
- Install pgcrypto extension via contrib class [\#80](https://github.com/Icinga/puppet-icinga/pull/80) ([lbetz](https://github.com/lbetz))
- fix broken idempotency on Debian [\#78](https://github.com/Icinga/puppet-icinga/pull/78) ([lbetz](https://github.com/lbetz))

**Merged pull requests:**

- Remove setting of default db ports in modules [\#76](https://github.com/Icinga/puppet-icinga/pull/76) ([lbetz](https://github.com/lbetz))

## [v3.0.1](https://github.com/icinga/puppet-icinga/tree/v3.0.1) (2023-02-02)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v3.0.0...v3.0.1)

**Fixed bugs:**

- Fix php extentions mysql and process [\#75](https://github.com/Icinga/puppet-icinga/pull/75) ([lbetz](https://github.com/lbetz))

## [v3.0.0](https://github.com/icinga/puppet-icinga/tree/v3.0.0) (2023-01-31)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.9.1...v3.0.0)

**Implemented enhancements:**

- Add Ubuntu jammy support [\#62](https://github.com/Icinga/puppet-icinga/issues/62)
- Add datatype sensitive to all passwords in all classes [\#73](https://github.com/Icinga/puppet-icinga/pull/73) ([lbetz](https://github.com/lbetz))
- Add IcingaDB support [\#72](https://github.com/Icinga/puppet-icinga/pull/72) ([lbetz](https://github.com/lbetz))

**Closed issues:**

- Rename default branch to main [\#74](https://github.com/Icinga/puppet-icinga/issues/74)
- Add example for using the Icinga Subscription Repo [\#69](https://github.com/Icinga/puppet-icinga/issues/69)

## [v2.9.1](https://github.com/icinga/puppet-icinga/tree/v2.9.1) (2023-01-02)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.9.0...v2.9.1)

**Fixed bugs:**

- Database schema import always failed for PostgreSQL [\#71](https://github.com/Icinga/puppet-icinga/issues/71)
- error: Could not find template 'icinga/apache\_custom\_default.conf' [\#70](https://github.com/Icinga/puppet-icinga/issues/70)

## [v2.9.0](https://github.com/icinga/puppet-icinga/tree/v2.9.0) (2022-12-27)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.8.0...v2.9.0)

**Implemented enhancements:**

- Add management of databases for icingadb [\#66](https://github.com/Icinga/puppet-icinga/issues/66)
- Fix Warnings and Errors from pdk validate [\#37](https://github.com/Icinga/puppet-icinga/issues/37)
- Add param manage\_crb to class icinga::repos [\#68](https://github.com/Icinga/puppet-icinga/pull/68) ([lbetz](https://github.com/lbetz))

## [v2.8.0](https://github.com/icinga/puppet-icinga/tree/v2.8.0) (2022-07-26)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.7.1...v2.8.0)

**Implemented enhancements:**

- Add parameter for initial admin user and password to Icinga Web 2 [\#65](https://github.com/Icinga/puppet-icinga/issues/65)
- Remove management of redis [\#64](https://github.com/Icinga/puppet-icinga/issues/64)

**Fixed bugs:**

- The director database requires the postgresql extention pgcrypto [\#61](https://github.com/Icinga/puppet-icinga/issues/61)
- Support Alma and Rocky Linux [\#55](https://github.com/Icinga/puppet-icinga/issues/55)

## [v2.7.1](https://github.com/icinga/puppet-icinga/tree/v2.7.1) (2022-05-30)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.7.0...v2.7.1)

**Fixed bugs:**

- Fix unsupported apache feature CGIPassAuth for older version like on RHEL7 [\#58](https://github.com/Icinga/puppet-icinga/issues/58)

## [v2.7.0](https://github.com/icinga/puppet-icinga/tree/v2.7.0) (2022-03-08)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.6.1...v2.7.0)

**Implemented enhancements:**

- Add support to manage repo server\_monitoring on SLES [\#57](https://github.com/Icinga/puppet-icinga/issues/57)
- Change apache mpm from worker to event [\#53](https://github.com/Icinga/puppet-icinga/issues/53)
- Manage PowerTools on CentOS8 and other clones [\#42](https://github.com/Icinga/puppet-icinga/issues/42)

**Fixed bugs:**

- Remove management of Fedora's EPEL from OracleLinux  [\#56](https://github.com/Icinga/puppet-icinga/issues/56)

## [v2.6.1](https://github.com/icinga/puppet-icinga/tree/v2.6.1) (2022-01-14)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.6.0...v2.6.1)

**Fixed bugs:**

- Do not set an api user for the director and icingaweb2 if the password is empty [\#54](https://github.com/Icinga/puppet-icinga/issues/54)
- Add missing mime apache module [\#52](https://github.com/Icinga/puppet-icinga/issues/52)

## [v2.6.0](https://github.com/icinga/puppet-icinga/tree/v2.6.0) (2022-01-05)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.5.0...v2.6.0)

**Implemented enhancements:**

- Add management of module fileshipper to director class [\#51](https://github.com/Icinga/puppet-icinga/issues/51)
- Update to https repos for Debian [\#50](https://github.com/Icinga/puppet-icinga/issues/50)

**Fixed bugs:**

- Update to https repos for Debian [\#50](https://github.com/Icinga/puppet-icinga/issues/50)

## [v2.5.0](https://github.com/icinga/puppet-icinga/tree/v2.5.0) (2021-12-03)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.4.2...v2.5.0)

**Implemented enhancements:**

- Add parameter to icinga to manage icingaweb2 group for the use of icingacli as plugins [\#49](https://github.com/Icinga/puppet-icinga/issues/49)
- Add vshperedb support [\#45](https://github.com/Icinga/puppet-icinga/issues/45)

**Fixed bugs:**

- Ubuntu focal does not know charset utf8 for mysql [\#48](https://github.com/Icinga/puppet-icinga/issues/48)
- Idempotency of icinga::web::director is broken [\#44](https://github.com/Icinga/puppet-icinga/issues/44)

## [v2.4.2](https://github.com/icinga/puppet-icinga/tree/v2.4.2) (2021-12-01)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.4.1...v2.4.2)

**Fixed bugs:**

- set import\_schema in web class to hiera lookup [\#34](https://github.com/Icinga/puppet-icinga/issues/34)

## [v2.4.1](https://github.com/icinga/puppet-icinga/tree/v2.4.1) (2021-11-05)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.4.0...v2.4.1)

**Fixed bugs:**

- Debian Bullseye support is broken [\#43](https://github.com/Icinga/puppet-icinga/issues/43)

## [v2.4.0](https://github.com/icinga/puppet-icinga/tree/v2.4.0) (2021-11-05)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.3.3...v2.4.0)

**Implemented enhancements:**

- Remove listen from icinga::web [\#40](https://github.com/Icinga/puppet-icinga/issues/40)
- Extend icinga::database with a parameter to set database encoding [\#39](https://github.com/Icinga/puppet-icinga/issues/39)
- Add director support [\#38](https://github.com/Icinga/puppet-icinga/issues/38)

## [v2.3.3](https://github.com/icinga/puppet-icinga/tree/v2.3.3) (2021-09-03)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.3.2...v2.3.3)

**Fixed bugs:**

- Namespace function postgresql::postgresql\_password does not work on Puppet 5 [\#36](https://github.com/Icinga/puppet-icinga/issues/36)

## [v2.3.2](https://github.com/icinga/puppet-icinga/tree/v2.3.2) (2021-08-17)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.3.1...v2.3.2)

**Fixed bugs:**

- using data types of another module breaks puppet 5 compatibility [\#35](https://github.com/Icinga/puppet-icinga/issues/35)

## [v2.3.1](https://github.com/icinga/puppet-icinga/tree/v2.3.1) (2021-06-21)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.3.0...v2.3.1)

**Fixed bugs:**

- NETWAYS repos named the suffix -release by there packages [\#33](https://github.com/Icinga/puppet-icinga/issues/33)

## [v2.3.0](https://github.com/icinga/puppet-icinga/tree/v2.3.0) (2021-06-05)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Add parameter zone to agent and cert\_name to icinga class [\#28](https://github.com/Icinga/puppet-icinga/issues/28)
- Add support for Suse [\#25](https://github.com/Icinga/puppet-icinga/issues/25)

**Fixed bugs:**

- web\_api\_user has to manage only on config\_server's [\#30](https://github.com/Icinga/puppet-icinga/issues/30)
- Parameter api\_host of class web  should be also a list of Stdlib::Host [\#29](https://github.com/Icinga/puppet-icinga/issues/29)
- Option to switch off the package management on windows [\#27](https://github.com/Icinga/puppet-icinga/issues/27)

## [v2.2.0](https://github.com/icinga/puppet-icinga/tree/v2.2.0) (2021-05-19)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.1.4...v2.2.0)

**Implemented enhancements:**

- Add direct management of logging to server, worker and agent [\#23](https://github.com/Icinga/puppet-icinga/issues/23)
- Rework unit tests for class repos [\#19](https://github.com/Icinga/puppet-icinga/issues/19)
- Add management of extra packages [\#17](https://github.com/Icinga/puppet-icinga/issues/17)

## [v2.1.4](https://github.com/icinga/puppet-icinga/tree/v2.1.4) (2021-05-04)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.1.3...v2.1.4)

**Fixed bugs:**

- Broken dependency for yumrepos [\#22](https://github.com/Icinga/puppet-icinga/issues/22)

## [v2.1.3](https://github.com/icinga/puppet-icinga/tree/v2.1.3) (2021-05-04)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.1.2...v2.1.3)

**Fixed bugs:**

- Using wrong file names for repos plugins and extras [\#21](https://github.com/Icinga/puppet-icinga/issues/21)
- manage\_epel do not work [\#20](https://github.com/Icinga/puppet-icinga/issues/20)

## [v2.1.2](https://github.com/icinga/puppet-icinga/tree/v2.1.2) (2021-04-26)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.1.1...v2.1.2)

**Fixed bugs:**

- Setting config\_server manage a zones directory named zone [\#18](https://github.com/Icinga/puppet-icinga/issues/18)

## [v2.1.1](https://github.com/icinga/puppet-icinga/tree/v2.1.1) (2021-04-26)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.1.0...v2.1.1)

**Fixed bugs:**

- Setting manage for any repo does not work [\#16](https://github.com/Icinga/puppet-icinga/issues/16)

## [v2.1.0](https://github.com/icinga/puppet-icinga/tree/v2.1.0) (2021-04-24)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Add new class to manage Icinga Web 2 [\#15](https://github.com/Icinga/puppet-icinga/issues/15)
- Add new class to supports IDO [\#14](https://github.com/Icinga/puppet-icinga/issues/14)
- Add new classes for simple managing  [\#13](https://github.com/Icinga/puppet-icinga/issues/13)
- Add new repo packages.netways.de/plugins [\#12](https://github.com/Icinga/puppet-icinga/issues/12)
- Add new repo packages.netways.de/extras [\#11](https://github.com/Icinga/puppet-icinga/issues/11)

**Closed issues:**

- Fresh roll-out apt\_key dependency error [\#10](https://github.com/Icinga/puppet-icinga/issues/10)
- Duplicate declaration: Yumrepo\[epel\] is already declared [\#9](https://github.com/Icinga/puppet-icinga/issues/9)

## [v2.0.0](https://github.com/icinga/puppet-icinga/tree/v2.0.0) (2021-01-11)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v1.0.3...v2.0.0)

**Fixed bugs:**

- Change Management Behavoir for Repositories [\#6](https://github.com/Icinga/puppet-icinga/issues/6)

**Closed issues:**

- Add Dependency to puppet-redis [\#8](https://github.com/Icinga/puppet-icinga/issues/8)

## [v1.0.3](https://github.com/icinga/puppet-icinga/tree/v1.0.3) (2020-10-22)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v1.0.2...v1.0.3)

**Fixed bugs:**

- fix gpgkey for epel EL8 [\#5](https://github.com/Icinga/puppet-icinga/pull/5) ([lbetz](https://github.com/lbetz))

## [v1.0.2](https://github.com/icinga/puppet-icinga/tree/v1.0.2) (2020-10-13)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v0.1.2...v1.0.2)

**Implemented enhancements:**

- Remove repo management of SCL [\#2](https://github.com/Icinga/puppet-icinga/issues/2)
- Add a relase guide [\#1](https://github.com/Icinga/puppet-icinga/issues/1)

**Closed issues:**

- correct fixtures and metadata [\#4](https://github.com/Icinga/puppet-icinga/issues/4)

## [v0.1.2](https://github.com/icinga/puppet-icinga/tree/v0.1.2) (2020-04-21)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v0.1.1...v0.1.2)

## [v0.1.1](https://github.com/icinga/puppet-icinga/tree/v0.1.1) (2020-04-20)
[Full Changelog](https://github.com/icinga/puppet-icinga/compare/v0.1.0...v0.1.1)

## [v0.1.0](https://github.com/icinga/puppet-icinga/tree/v0.1.0) (2020-04-20)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*