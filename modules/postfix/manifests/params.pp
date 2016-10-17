# = Class: postfix::params
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
# class postfix::someclass( packages = $postfix::params::some_param
# ) inherits postfix::params {
# ...do something
# }
#
# class { 'postfix::params' : }
#
# include postfix::params
#
class postfix::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports postfix version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $postfix_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'postfix-package',
    }
    $postfix_services = {
      'postfix' => {
        'ensure'  => 'running',
        'enable'  => true,
      }
    }
    $postfix_packages = {
      'postfix'        => {},
    }
    $postfix_configs = {
      '/etc/postfix/main.cf'        => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('postfix/Ubuntu/precise/main.cf.erb'),
          default   => template('postfix/Ubuntu/main.cf.erb'),
        }
      },
      '/etc/postfix/master.cf'      => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/mailname'               => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::fqdn,
      },
      '/var/spool/postfix/var'      => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/var/spool/postfix/var/run'  => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
