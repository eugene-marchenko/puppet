# Class: roles::misc::vhosts
#
# This class installs miscellaneous one-off vhost resources
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
# include roles::misc::vhosts
#
# class { 'roles::misc::vhosts' : }
#
#
class roles::misc::vhosts() {

  include roles::base

  include roles::misc::mounts
  Mount <| title == "${roles::misc::mounts::path}" |>

  include apache
  include php
  realize Package[php5-mysql]
  include apache::mod::php
  A2mod <| title == 'speling' |>

  apache::vhost::proxy { 'demo.thedailybeast.com' :
    port                  => '80',
    docroot               => '/var/www',
    dest                  => 'http://demo.thedailybeast.com.s3-website-us-east-1.amazonaws.com',
    proxy_auth            => true,
    request_header_unset  => [ 'Authorization' ],
  }

  apache::vhost::proxy { 'brands.thedailybeast.com' :
    port                  => '80',
    docroot               => '/var/www',
    dest                  => 'http://brands.thedailybeast.com.s3-website-us-east-1.amazonaws.com',
    proxy_auth            => true,
    request_header_unset  => [ 'Authorization' ],
  }

  file { '/etc/apache2/password.file' :
    ensure  => 'present',
    owner   => 'root',
    group   => 'www-data',
    mode    => '0640',
    source  => 'puppet:///modules/data/apache/password.file',
  }

  # Anchor the class
  Class[roles::base]
  -> Mount[$roles::misc::mounts::path]
  -> Class[php]
  -> Package[php5-mysql]
  -> Class[apache]
  -> Class[apache::mod::php]
  -> File['/etc/apache2/password.file']
  -> Apache::Vhost::Proxy['demo.thedailybeast.com']
  -> Apache::Vhost::Proxy['brands.thedailybeast.com']

}
