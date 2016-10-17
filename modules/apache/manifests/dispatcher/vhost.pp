# Define: apache::dispatcher::vhost
#
# This class installs Apache Virtual Hosts
#
# == Parameters:
#
# == Required:
#
# $port::             The port to configure the host on
#
# $renders::          The render hosts to connect to.
#
# $docroot::          The DocumentRoot on the filesystem of the vhost
#
# == Optional:
#
# $enable::           Whether to enable the virtualhost or not.
#
# $default_vhost::    Whether this vhost is the default virtualhost. Default is
#                     false.
#
# $ssl::              Boolean to enable SSL for this Virtual Host. Defaults to
#                     false.
#
# $ssl_cert::         The path to the SSL Certificate. Default taken from
#                     apache::params.
#
# $ssl_key::          The path to the SSL Key. Default taken from
#                     apache::params.
#
# $ssl_chain::        The path to the SSL Intermediate Chain file. Default taken
#                     from apache::params.
#
# $vhost_template::   The template to use for the virtualhost config. This
#                     option specifies whether to use the default one or
#                     override.
#
# $d_tmpl::           The template to use for the dispatcher.any config
#                     fragment. This option specifies whether to use the default
#                     template or override.
#
# $d_tmpl_priority::  The priority to use for the file fragment. This allows you
#                     to properly order files for reconstruction. Default is 10.
#
# $d_tmpl_target::    The target configuration file this fragment belongs to.
#                     This options specifies whether to use the default
#                     location or override. Default is
#                     /etc/apache2/dispatcher.any
#
# $log_dir::          The log directory to write log files to. Defaults to
#                     apache::params
#
# $priority::         The priority of the virtualhost site
#
# $servername::       To be used in the ServerName directive, if not specified
#                     then the namevar is used.
#
# $serveraliases::    The server aliases of the site
#
# $options::          The options for the given vhost
#
# $vhost_name::       The name for name based virtualhosting, defaulting to *
#
# $ports_conf::       The path to the ports.conf file for ensuring that apache
#                     is listening on the port specified for the vhost.
#
# == Requires:
# stdlib, apache, apache::ssl, concat
#
# == Sample Usage:
# apache::dispatcher::vhost { 'site.name.fqdn':
#   priority => '20',
#   port => '80',
#   docroot => '/path/to/docroot',
# }
#
define apache::dispatcher::vhost(
    $port,
    $docroot,
    $renders,
    $enable           = true,
    $default_vhost    = false,
    $ssl              = false,
    $ssl_key          = $apache::params::apache_ssl_prv_key,
    $ssl_cert         = $apache::params::apache_ssl_cert,
    $ssl_chain        = $apache::params::apache_ssl_intermediate_cert,
    $vhost_template   = 'apache/dispatcher/vhost/default.conf.erb',
    $d_tmpl           = 'apache/dispatcher/vhost.any.erb',
    $d_tmpl_priority  = '10',
    $d_tmpl_target    = $apache::dispatcher::params::apache_dispatcher_conf,
    $log_dir          = $apache::params::apache_log_dir,
    $priority         = '',
    $servername       = '',
    $serveraliases    = '',
    $options          = 'Indexes FollowSymLinks',
    $apache_name      = 'apache2',
    $vhost_name       = '*',
    $ports_conf       = '/etc/apache2/ports.conf',
) {

  validate_bool($enable,$ssl,$default_vhost)

  include apache::dispatcher
  include concat::setup

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

  # Enable rewrite module
  A2mod <| title == 'rewrite' |>
  # Enable expires module
  A2mod <| title == 'expires' |>
  # Enable deflate module
  A2mod <| title == 'deflate' |>

  # Create the Document Root
  file { $docroot :
    ensure  => 'directory',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0755',
    require => Class[apache::dispatcher],
  }

  # Create site directory for storing extra files
  file { "/etc/${apache_name}/${name}" :
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Class[apache::dispatcher],
  }

  # Deploy the virtualhost file
  file { "/etc/${apache_name}/sites-available/${name_real}":
    ensure  => 'present',
    path    => "/etc/${apache_name}/sites-available/${name_real}",
    content => template($vhost_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class[apache::dispatcher],
    before  => A2site[$name_real],
    notify  => Class[apache::service],
  }

  # Create the virtualhost fragment for dispatcher.any config
  concat::fragment { "${d_tmpl_target}_${name}":
    target  => $d_tmpl_target,
    order   => $d_tmpl_priority,
    content => template($d_tmpl),
  }

  # Enable the site
  @a2site { $name_real :
    ensure  => 'present',
    require => Class[apache::dispatcher],
    notify  => Class[apache::service],
  }

  case $enable {
    false: {
      Concat::Fragment["${d_tmpl_target}_${name}"] {
        ensure  => 'absent',
      }
      A2site <| title == $name_real |> {
        ensure  => 'absent',
      }
    }
    default: {
      A2site <| title == $name_real |>
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

