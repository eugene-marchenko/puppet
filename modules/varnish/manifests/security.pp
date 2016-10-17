# Class: varnish::security
#
# This module installs varnish security vcls
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# == Requires:
#
# == Sample Usage:
#
# include varnish::security
#

class varnish::security (
  $installed = true,
) inherits varnish::params {

  include stdlib

  # directory tree

  file { '/etc/varnish/security':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/etc/varnish'],
  }

  file { '/etc/varnish/security/rules':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/etc/varnish/security'],
  }

  file { '/etc/varnish':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/varnish/security/security.vcl':
    content => template('varnish/security/security.vcl.erb'),
  }

  file { '/etc/varnish/security/handler.vcl':
    content => template('varnish/security/handler.vcl.erb'),
  }

  # security rules

  File {
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/varnish/security/rules/dailybeast.vcl':
    content => template('varnish/security/rules/dailybeast.vcl.erb'),
    require => File['/etc/varnish/security/rules'],
  }

  file { '/etc/varnish/security/rules/xss.vcl':
    content => template('varnish/security/rules/xss.vcl.erb'),
    require => File['/etc/varnish/security/rules'],
  }

  file { '/etc/varnish/security/rules/xss.encoded.vcl':
    content => template('varnish/security/rules/xss.encoded.vcl.erb'),
    require => File['/etc/varnish/security/rules'],
  }

  #file { '/etc/varnish/security/rules/':
  #  content => template('varnish/security/rules/'),
  #}

}
