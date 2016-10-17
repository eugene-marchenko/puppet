# = Class: build::params
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
# class build::someclass(
#   packages = $build::params::some_param
# ) inherits build::params {
# ...do something
# }
#
# class { 'build::params' : }
#
# include build::params
#
class build::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $build_base_packages = {
      'build-essential' => {},
    }
    $build_devlibs_packages = [
      'autoconf',
      'automake1.9',
      'autotools-dev',
      'comerr-dev',
      'dctrl-tools',
      'dbconfig-common',
      'devscripts',
      'dh-make',
      'diffstat',
      'dpatch',
      'dput',
      'g++',
      'libclass-accessor-perl',
      'libcurl4-gnutls-dev',
      'libgcrypt11-dev',
      'libgdbm-dev',
      'libglib2.0-0',
      'libgnutls-dev',
      'libgpg-error-dev',
      'libidn11-dev',
      'libiksemel3',
      'libiksemel-dev',
      'libio-string-perl',
      'libkrb5-dev',
      'libldap2-dev',
      'liblzo2-dev',
      'libmysqlclient-dev',
      'libncurses5-dev',
      'libopenipmi0',
      'libopenipmi-dev',
      'libparse-debianchangelog-perl',
      'libpq5',
      'libpq-dev',
      'libsnmp-dev',
      'libsnmp-perl',
      'libssl-dev',
      'libtasn1-3-dev',
      'libtool',
      'libwrap0-dev',
      'libxslt1.1',
      'lintian',
      'm4',
      'mysql-common',
      'pbuilder',
      'pkg-config',
      'python-debian',
      'python-libxml2',
      'quilt',
      'sloccount',
      'git-flow',
      'ubuntu-dev-tools',
      'vim',
      'vim-runtime',
      'xsltproc',
      'zlib1g-dev',
      'libxml2-dev',
      'libxslt1-dev',
      'libc6-i386',
      'libc6-dev-i386',
    ]
    $build_base_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'build-base-package',
    }
    $build_devtools_configs = {
      '/root/README.Debian' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/build/README.Debian',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
