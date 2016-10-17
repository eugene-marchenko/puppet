# Define: apache::vhost::redirect
#
# This define installs Apache Virtual Hosts for redirecting to another host.
#
# == Parameters:
#
# == Required:
#
# $port::           The port to configure the host on
#
# $dest::           The remote destination to map to the local URL-space.
#
# == Optional:
#
# $template::       This option specifies whether to use the default template or
#                   override.
#
# $ssl::            Boolean to enable SSL for this Virtual Host.
#
# $priority::       The priority of the site
#
# $serveraliases::  The server aliases of the site
#
# $vhost_name::     The name for name based virtualhosting, defaulting to *
#
# $ports_conf::     The path to the ports.conf file for ensuring that apache
#                   is listening on the port specified for the vhost.
#
# == Requires:
# stdlib, apache, apache::mod::ssl
#
# == Sample Usage:
# apache::vhost::redirect { 'site.name.fqdn':
#   port => '80',
#   dest => 'http://othersite.name.fqdn',
# }
#
define apache::vhost::redirect(
    $port,
    $dest,
    $enable         = true,
    $status         = 'permanent',
    $template       = 'apache/vhost/redirect.conf.erb',
    $priority       = '10',
    $servername     = '',
    $serveraliases  = '',
    $apache_name    = 'apache2',
    $vhost_name     = '*',
    $ports_conf     = '/etc/apache2/ports.conf',
    $ssl            = false,
    $ssl_key        = $apache::params::apache_ssl_prv_key,
    $ssl_cert       = $apache::params::apache_ssl_cert,
    $ssl_chain      = $apache::params::apache_ssl_intermediate_cert,
) {

  validate_bool($enable)

  include apache

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include apache::ssl
    $x_forwarded_proto = 'https'
  } else {
    $x_forwarded_proto = 'http'
  }

  if $priority != '' {
    $name_real = "${priority}-${name}"
  } else {
    $name_real = "${priority}${name}"
  }

  if ! ($status in [ 'permanent', 'temp', 'seeother', '307' ]) {
    fail("Invalid HTTP status code ${status} invalid")
  }

  # Enable mod_alias for Redirect directive
  A2mod <| title == 'alias' |>

  file { "/etc/${apache_name}/sites-available/${name_real}":
      ensure  => 'present',
      path    => "/etc/${apache_name}/sites-available/${name_real}",
      content => template($template),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Class[apache::service],
  }

  @a2site { $name_real :
    ensure  => 'present',
    require => File["/etc/${apache_name}/sites-available/${name_real}"],
    notify  => Class[apache::service],
  }

  if $enable == true {
    A2site <| title == $name_real |>
  } else {
    A2site <| title == $name_real |> {
      ensure  => 'absent',
    }
  }

  if $hostname !~ /^qa06/ {
    file_line { "${ports_conf}-${name}-${port}" :
      path    => $ports_conf,
      line    => "Listen ${port}",
      require => Class[apache],
      notify  => Class[apache::service],
    }
  }

  if $hostname !~ /^qa06/ {
    file_line { "${ports_conf}-${name}-namevirtualhost-${vhost_name}:${port}" :
      path    => $ports_conf,
      line    => "NameVirtualHost ${vhost_name}:${port}",
      require => Class[apache],
      notify  => Class[apache::service],
    }
  }

}

