# = Class: puppet::params
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
# class puppet::someclass( packages = $puppet::params::some_param
# ) inherits puppet::params {
# ...do something
# }
#
# class { 'puppet::params' : }
#
# include puppet::params
#
class puppet::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $puppet_client_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'puppet-client-package',
    }
    $puppet_client_services = {
      'puppet' => {
        'enable'  => false,
      }
    }
    $puppet_client_packages = {
      'puppet'        => {},
      'puppet-common' => {},
    }
    $puppet_client_configs = {
      '/etc/puppet/puppet.conf' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/default/puppet'     => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('puppet/Ubuntu/precise/default.erb'),
          default   => template('puppet/default.erb')
        }
      },
    }
    $puppet_master_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'puppet-master-package',
    }
    $puppet_master_configs = {
      'master-/etc/puppet/puppet.conf'            => {
        'ensure'  => 'present',
        'path'    => '/etc/puppet/puppet.conf',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/puppet/auth.conf'                     => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/puppet/fileserver.conf'               => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/apache2/sites-available/puppetmaster' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
    }

    case $::lsbdistcodename {
      'precise': {
        $puppet_master_packages = {
          'puppetmaster-common'     => {},
          'puppetmaster-passenger'  => {},
        }
        $puppet_master_services = { }
      }
      default: {
        $puppet_master_packages = {
          'puppetmaster'  => { require => Class[apache2] },
        }
        $puppet_master_services = {
          'puppetmaster'  => {
            'ensure'  => 'running',
            'enable'  => true,
          },
        }
      }
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
