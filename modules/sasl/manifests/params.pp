# = Class: sasl::params
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
# class sasl::someclass( packages = $sasl::params::some_param
# ) inherits sasl::params {
# ...do something
# }
#
# class { 'sasl::params' : }
#
# include sasl::params
#
class sasl::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports sasl version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # By default Postfix runs chrooted
    if $::postfix_chroot {
      $parent_directory = $::postfix_chroot
    } else {
      $parent_directory = ''
    }

    $saslauthd_options = "-c -m ${parent_directory}/var/run/saslauthd"

    $sasl_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'sasl-package',
    }
    $sasl_services = {
      'saslauthd' => {
        'ensure'  => 'stopped',
        'enable'  => false,
      }
    }
    $sasl_packages = {
      'sasl2-bin'         => {},
      'libgsasl7'         => {},
      'libsasl2-2'        => {},
      'libsasl2-modules'  => {},
    }
    $sasl_configs = {
      '/etc/default/saslauthd'                  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('sasl/Ubuntu/precise/default.erb'),
          default   => template('sasl/Ubuntu/default.erb'),
        },
      },
      "${parent_directory}/etc/sasldb2"         => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'sasl',
        'mode'    => '0660',
      },
      "${parent_directory}/var/run/saslauthd"   => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'sasl',
        'mode'    => '710',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
