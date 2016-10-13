# Class: roles::cq5::author::secure
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
# include roles::cq5::author::secure
#
# class { 'roles::cq5::author::secure' : }
#
#
class roles::cq5::author::secure() {

  include roles::base

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
    priority       => '15',
    servername     => $cq5_author_hostname,
    serveraliases  => [ 'author.ec2.newsweek.com',
                      'author-uat.ec2.newsweek.com',
                      ],
    redirect_ssl   => true,
  }

  apache::vhost::proxy { "${cq5_author_hostname}_443" :
    port           => '443',
    docroot        => '/var/www',
    priority       => '15',
    servername     => $cq5_author_hostname,
    serveraliases  => [ 'author.ec2.newsweek.com',
                      'author-uat.ec2.newsweek.com',
                      'author.thedailybeast.com',
                      'author.ec2.thedailybeast.com',
                      'author-uat.ec2.thedailybeast.com',
                      ],
    ssl            => true,
    ssl_cert       => $cq5_author_ssl_cert,
    dest           => "http://${cq5_author_hostname}:${cq5_author_port}",
    proxy_deny     => '/robots.txt',
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
  ->  Apache::Vhost['default']
  ->  Apache::Vhost["${cq5_author_hostname}_80"]
  ->  Apache::Vhost::Proxy["${cq5_author_hostname}_443"]
  ->  File['/var/www/robots.txt']
}
