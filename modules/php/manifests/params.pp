# = Class: php::params
#
# This module manages default parameters. It does the heavy lifting
# to determine operating system specific parameters.
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class php::someclass(
#   packages = $php::params::some_param
# ) inherits php::params {
# ...do something
# }
#
# class { 'php::params' : }
#
# include php::params
#
class php::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $php_base_packages = {
      'php5' => {},
    }
    $php_packages = [
      'php-pear',
      'php5-cgi',
      'php5-common',
      'php5-curl',
      'php5-dbg',
      'php5-dev',
      'php5-gd',
      'php5-gmp',
      'php5-ldap',
      'php5-mysql',
      'php5-mcrypt',
      'php5-odbc',
      'php5-pgsql',
      'php5-pspell',
      'php5-recode',
      'php5-snmp',
      'php5-sqlite',
      'php5-tidy',
      'php5-xmlrpc',
      'php5-xsl',
    ]
    $php_base_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'php-base-package',
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
