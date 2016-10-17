# Class: apache::dispatcher
#
# This class manages apache dispatcher files and vhosts
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the apache dispatcher is installed or
#                   not. Valid values are true and false. Defaults to true.
#
# $vhosts::         An array of virtualhosts to install.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $apache::dispatcher::params::apache_configs.
#
# == Requires:
#
# stdlib, apache::dispatcher::params, concat
#
# == Sample Usage:
# include apache::dispatcher
#
# class { 'apache::dispatcher' : installed => false }
#
class apache::dispatcher(
  $installed        = true,
  $dispatcher_conf  = hiera('apache_dispatcher_conf'),
  $configs          = hiera('apache_dispatcher_configs'),
) inherits apache::dispatcher::params {

  include stdlib
  include apache
  include concat::setup

  validate_bool($installed)
  validate_hash($configs)

  # Initialize dispatcher.any config for fragment building
  concat { $dispatcher_conf : }
  concat::fragment { "${dispatcher_conf}_head" :
    target  => $dispatcher_conf,
    order   => '0',
    content => template('apache/dispatcher/head.any.erb'),
  }

  concat::fragment { "${dispatcher_conf}_tail" :
    target  => $dispatcher_conf,
    order   => '99',
    content => template('apache/dispatcher/tail.any.erb'),
  }

  case $installed {
    true: {
      # Create static configs
      apache::config  { 'apache-dispatcher-configs' :  configs => $configs }
      # Activate headers module
      A2mod <| title == 'headers' |>
      # Activate dispatch module
      a2mod { 'dispatcher' : ensure  => 'present' }

      Apache::Config[apache-dispatcher-configs]
      -> A2mod[dispatcher]

      if defined(Class[apache::service]) {
        Apache::Config[apache-dispatcher-configs]   ~> Class[apache::service]
        A2mod[dispatcher]                           ~> Class[apache::service]
        Concat[$dispatcher_conf]                    ~> Class[apache::service]
      }

      motd::register { 'Apache::Dispatcher' : }

    }
    false: {
      a2mod { 'dispatcher' : ensure => 'absent' }

      anchor{'apache::dispatcher::begin':}  -> A2mod[dispatcher]
      A2mod[dispatcher]                     -> anchor{'apache::dispatcher::end':}

      if defined(Class[apache::service]) {
        A2mod[dispatcher]       ~> Class[apache::service]
      }
    }
    # Do Nothing.
    default: {}
  }
}
