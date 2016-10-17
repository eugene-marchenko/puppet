# Define: apache::vhost::proxy
#
# This class installs Apache Virtual Hosts
#
# == Parameters:
#
# == Required:
#
# $port::                 The port to configure the host on.
#
# $dest::                 The remote destination to map to the local URL-space.
#
# $docroot::              The local directory to use for any local files you may
#                         have.
#
# == Optional:
#
# $src::                  And optional local URL-space to map. Defaults to the
#                         root '/' space.
#
# $proxy_deny::           Disallow proxy mapping of URL-space denoted by this
#                         string or array of strings.
#
# $proxy_preserve_host::  Whether to use the host header of the request or the
#                         host defined in the proxypass directive. Turn to On
#                         to use the one in the request. Default is On.
#
# $enable::               Whether to enable the virtualhost or not.
#
# $allow::                The hosts or ip ranges to allow access to this site.
#
# $ssl::                  Boolean to enable SSL for this Virtual Host.
#
# $template::             This option specifies whether to use the default
#                         template or override.
#
# $log_dir::              The log directory for vhost log files. Default from
#                         apache::params.
#
# $priority::             The priority of the site.
#
# $serveraliases::        The server aliases of the site.
#
# $options::              The options for the given vhost.
#
# $overrides::            The overrides to allow under the docroot.
#
# $vhost_name::           The name for name based virtualhosting, defaulting to
#                         *.
#
# $ports_conf::           The path to the ports.conf file for ensuring that
#                         apache is listening on the port specified for the
#                         vhost.
#
# $proxy_auth::           Whether this proxy will perform http authentication.
#                         Defaults to false.
#
# $proxy_auth_type::      The type of authentication. Defaults to Basic.
#
# $proxy_auth_name::      The message to prompt the user with.
#
# $proxy_auth_userfile::  The password file to use.
#
# $header_set::           The Headers to add to the response to the client.
#
# $header_unset::         The Headers to remove in the response to the client.
#
# $request_header_set::   The Headers to add to the proxy request to the
#                         backend. Should be an Array of Name=Value strings.
#
# $request_header_unset:: The Headers to remove from the proxy request to the
#                         backend. Should be an Array of strings.
#
# == Requires:
# stdlib, apache, apache::mod::ssl
#
# == Sample Usage:
# apache::vhost::proxy { 'site.name.fqdn':
#   port    => '80',
#   docroot => '/var/www',
#   dest    => 'http://site.name.fqdn:8080',
# }
#
define apache::vhost::proxy(
    $port,
    $dest,
    $docroot,
    $src                    = '',
    $proxy_deny             = undef,
    $proxy_preserve_host    = 'On',
    $enable                 = true,
    $allow                  = 'all',
    $ssl                    = false,
    $ssl_key                = $apache::params::apache_ssl_prv_key,
    $ssl_cert               = $apache::params::apache_ssl_cert,
    $ssl_chain              = $apache::params::apache_ssl_intermediate_cert,
    $template               = 'apache/vhost/proxy.conf.erb',
    $log_dir                = $apache::params::apache_log_dir,
    $priority               = '',
    $servername             = '',
    $serveraliases          = '',
    $options                = 'Indexes FollowSymLinks MultiViews',
    $overrides              = 'None',
    $apache_name            = 'apache2',
    $vhost_name             = '*',
    $ports_conf             = '/etc/apache2/ports.conf',
    $proxy_auth             = false,
    $proxy_auth_type        = 'Basic',
    $proxy_auth_name        = 'Password Required',
    $proxy_auth_userfile    = "${apache::params::apache_root}/password.file",
    $header_set             = [],
    $header_unset           = [],
    $request_header_set     = [],
    $request_header_unset   = [],
) {

  validate_bool($enable,$ssl)

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

  # Determine default request header params from vhost params
  # Add them to the request_header_set Array.
  $request_header_set_real = [ "X-Forwarded-Port=${port}",
                          "X-Forwarded-Proto=${x_forwarded_proto}",
                          $request_header_set,
                        ]

  # Enable headers module
  A2mod <| title == 'headers' |>

  # Enable proxy module
  A2mod <| title == 'proxy_http' |>

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

