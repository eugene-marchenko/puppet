# Class: roles::appproxy
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
# include roles::appproxy
#
# class { 'roles::appproxy' : }
#
#
class roles::appproxy() {

  include roles::base
  include apache

  apache::vhost::proxy { 'app.thedailybeast.com_80' :
    servername    => 'app.thedailybeast.com',
    port          => '80',
    dest          => 'http://qa02.ec2.newsweek.com:6081',
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'app.thedailybeast.com_443' :
    servername    => 'app.thedailybeast.com',
    port          => '443',
    dest          => 'http://qa02.ec2.newsweek.com:6081',
    docroot       => '/var/www',
    ssl_cert      => $apache::params::apache_ssl_cert_tdb,
    ssl           => true,
  }

  motd::register { 'PPProxy': }

  Class[roles::base]
  -> Class[Apache]
  -> Apache::Vhost::Proxy['app.thedailybeast.com_80']
  -> Apache::Vhost::Proxy['app.thedailybeast.com_443']
}
