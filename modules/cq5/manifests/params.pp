# = Class: cq5::params
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
# class cq5::someclass( packages = $cq5::params::some_param
# ) inherits cq5::params {
# ...do something
# }
#
# class { 'cq5::params' : }
#
# include cq5::params
#
class cq5::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports cq5 version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Fact defaults

    if 'publisher' in $::roles and 'author' in $::roles {
      $cq5_path = $::cq5_publish_path
    } elsif 'author' in $::roles {
      $cq5_path = $::cq5_author_path
    } elsif 'publish' in $::roles {
      $cq5_path = $::cq5_publish_path
    }

    # Resource defaults
    $cq5_configs = {
      '/usr/local/bin/create_support_files.sh'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'source'  => 'puppet:///modules/cq5/scripts/create_support_files.sh',
      },
      '/usr/local/bin/vlt_copy.sh'              => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'source'  => 'puppet:///modules/cq5/scripts/vlt_copy.sh',
      },

      '/usr/local/bin/vlt'    => {
        'ensure' => 'link',
        'target' => "${cq5_path}/crx-quickstart/opt/filevault/vault-cli-2.3.6/bin/vlt",
      },

      '/usr/local/bin/crx_restart.py'           => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'source'  => 'puppet:///modules/cq5/scripts/crx_restart.py',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
