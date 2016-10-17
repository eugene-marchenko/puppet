# = Class: route53::params
#
# This module manages user default parameters. It does the heavy lifting
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
# class route53::someclass( address = $route53::params::address
# ) inherits route53::params {
# ...do something
# }
#
# class { 'route53::params' : }
#
# include route53::params
#
class route53::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    case $::lsbdistcodename {
      default: {
        if $::route53_aws_access_key {
          $access_key = $::route53_aws_access_key
        } else {
          fail('Fact route53_aws_access_key does not exist')
        }

        if $::route53_aws_secret_access_key {
          $secret_access_key = $::route53_aws_secret_access_key
        } else {
          fail('Fact route53_aws_secret_access_key does not exist')
        }

        if $::ec2_public_hostname {
          $address = $::ec2_public_hostname
          $type    = 'CNAME'
        } else {
          $address = $::ipaddress
          $type    = 'A'
        }

        $hostname = $::hostname
        $domain = $::domain
        $ttl = 60
        $defaults = {
          'ensure' => 'present',
          'mode'   => '0700',
          'owner'  => 'root',
          'group'  => 'root',
        }
        $cliscript      = '/usr/local/bin/cli53.py'
        $initscript     = '/etc/init.d/r53'
        $route53_files  = {
          '/etc/init.d/r53'         => {
            'path'    => '/etc/init.d/r53',
            'content' => template('route53/r53.erb'),
            'require' => 'File[/usr/local/bin/cli53.py]',
          },
          '/usr/local/bin/cli53.py' => {
            'path'    => '/usr/local/bin/cli53.py',
            'source'  => 'puppet:///modules/route53/cli53.py',
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
