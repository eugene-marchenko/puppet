# Class: roles::debbuilder
#
# This meta class installs cron resources
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::debbuilder
#
# class { 'roles::debbuilder' : }
#
#
class roles::debbuilder() {

  include roles::base
  include roles::backports
  include build::devtools

  motd::register { 'Debian-Notice':
    content => 'DEBIAN PACKAGING NOTICE: View /root/README.Debian',
    order   => '51',
  }

  File {
    mode  => '0600',
    owner => 'root',
    group => 'root',
  }

  file { '/root/.gnupg' :
    ensure  => 'directory',
    path    => '/root/.gnupg',
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
  }

  file { '/root/.gnupg/gpg.conf' :
    ensure  => 'present',
    path    => '/root/.gnupg/gpg.conf',
    source  => 'puppet:///modules/data/.gnupg/gpg.conf',
  }

  file { '/root/.gnupg/pubring.gpg' :
    ensure  => 'present',
    path    => '/root/.gnupg/pubring.gpg',
    source  => 'puppet:///modules/data/.gnupg/pubring.gpg',
  }

  file { '/root/.gnupg/secring.gpg' :
    ensure  => 'present',
    path    => '/root/.gnupg/secring.gpg',
    source  => 'puppet:///modules/data/.gnupg/secring.gpg',
  }

  file { '/root/.gnupg/trustdb.gpg' :
    ensure  => 'present',
    path    => '/root/.gnupg/trustdb.gpg',
    source  => 'puppet:///modules/data/.gnupg/trustdb.gpg',
  }

  Class[roles::base]
  -> Class[build::devtools]
  -> File['/root/.gnupg']
  -> File['/root/.gnupg/gpg.conf']
  -> File['/root/.gnupg/pubring.gpg']
  -> File['/root/.gnupg/secring.gpg']
  -> File['/root/.gnupg/trustdb.gpg']
}
