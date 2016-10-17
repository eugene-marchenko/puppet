# Define: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# == Parameters:
#
# == Required:
#
# $port::           The port to configure the host on
#
# $docroot::        The DocumentRoot on the filesystem of the vhost
#
# == Optional:
#
# $enable::         Whether this virtualhost is enabled or not.
#
# $allow::          The hosts or ip ranges to allow access to this site.
#
# $ssl::            Boolean to enable SSL for this Virtual Host
#
# $template::       This option specifies whether to use the default template or
#                   override.
#
# $log_dir::        The log directory for vhost log files. Default from
#                   apache::params
#
# $priority::       The priority of the site
#
# $serveraliases::  The server aliases of the site
#
# $options::        The options for the given vhost
#
# $overrides::      The overrides to allow under the docroot
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
# apache::vhost { 'site.name.fqdn':
#   priority => '20',
#   port => '80',
#   docroot => '/path/to/docroot',
# }
#
define apache::vhost(
    $port,
    $docroot,
    $enable         = true,
    $allow          = 'all',
    $ssl            = false,
    $ssl_key        = $apache::params::apache_ssl_prv_key,
    $ssl_cert       = $apache::params::apache_ssl_cert,
    $ssl_chain      = $apache::params::apache_ssl_intermediate_cert,
    $template       = 'apache/vhost/default.conf.erb',
    $log_dir        = $apache::params::apache_log_dir,
    $priority       = '',
    $servername     = '',
    $serveraliases  = '',
    $redirect_ssl   = false,
    $options        = 'Indexes FollowSymLinks MultiViews',
    $overrides      = 'None',
    $apache_name    = 'apache2',
    $vhost_name     = '*',
    $ports_conf     = '/etc/apache2/ports.conf',
) {

  validate_bool($enable,$ssl,$redirect_ssl)

  include apache

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include apache::ssl
  }

  if $priority != '' {
    $name_real = "${priority}-${name}"
  } else {
    $name_real = "${priority}${name}"
  }

  # Since the template will redirect to https, require mod_rewrite
  if $redirect_ssl == true {
    A2mod <| title == 'rewrite' |>
  }

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

# if ( $::env == prod and $hostname =~ /^dispatch(\d+)/ ) {
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

