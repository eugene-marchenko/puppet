# Class: roles::cq5::author::secure_cache
#
# This class installs cq5::author resources
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
# include roles::cq5::author::secure_cache
#
# class { 'roles::cq5::author::secure_cache' : }
#
#
class roles::cq5::author::secure_cache() {

  include roles::base
  include apache::dispatcher

  # Validate some optional facts
  if $::cq5_author_port {
    $cq5_author_port = $::cq5_author_port
  } else {
    $cq5_author_port = '8080'
  }

  if $::cq5_author_hostname {
    $cq5_author_hostname = $::cq5_author_hostname
  } else {
    $cq5_author_hostname = $::fqdn
  }

  if $::cq5_author_ssl_cert {
    $cq5_author_ssl_cert = $::cq5_author_ssl_cert
  } else {
    $cq5_author_ssl_cert = $apache::params::apache_ssl_cert
  }

  include apache
  include apache::vhost::default

  Apache::Vhost <| title == 'default' |> {
      enable => false,
  }

  apache::vhost { "${cq5_author_hostname}_80" :
    port           => '80',
    docroot        => '/var/www',
    priority       => '05',
    servername     => $cq5_author_hostname,
    serveraliases  => [ 'author.ec2.newsweek.com',
                      'author-uat.ec2.newsweek.com',
                      ],
    redirect_ssl   => true,
  }

  apache::dispatcher::vhost { "${cq5_author_hostname}_443" :
    port            => '443',
    docroot         => "/mnt/dispatcher/${cq5_author_hostname}",
    priority        => '05',
    d_tmpl_priority => '30',
    d_tmpl          => 'apache/dispatcher/author-vhost.any.erb',
    renders         => [ "${cq5_author_hostname}:${cq5_author_port}" ],
    servername      => $cq5_author_hostname,
    serveraliases   => [ 'author.ec2.newsweek.com',
                      'author-uat.ec2.newsweek.com',
                      'author.thedailybeast.com',
                      'author.ec2.thedailybeast.com',
                      'author-uat.ec2.thedailybeast.com',
                      ],
    ssl             => true,
    ssl_cert        => $cq5_author_ssl_cert,
  }

  file { '/var/www/robots.txt' :
    ensure  => 'present',
    path    => '/var/www/robots.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "User-Agent *\nDisallow /\n",
  }

  Class[roles::base]
  ->  Class[apache]
  ->  Class[apache::dispatcher]

  Class[apache]
  ->  Apache::Vhost['default']
  ->  Apache::Vhost["${cq5_author_hostname}_80"]
  ->  Apache::Dispatcher::Vhost["${cq5_author_hostname}_443"]
  ->  File['/var/www/robots.txt']
}
