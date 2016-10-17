# Class: newrelic
#
#
class newrelic(
  $installed    = true,
  $packages     = hiera('newrelic_packages'),
  $defaults     = hiera('newrelic_package_defaults'),
  $configs      = hiera('newrelic_configs'),
) inherits newrelic::params {

  include stdlib
  include python

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      apt::source { 'newrelic' :
        location    => 'http://apt.newrelic.com/debian/',
        release     => 'newrelic',
        repos       => 'non-free',
        key         => '548C16BF',
        include_src => false,
      }

      group { 'newrelic':
        ensure => 'present',
        gid    => '2013',
        require  => Class['roles::packages'],
      }

      user { 'newrelic':
        ensure  => 'present',
        gid     => '2013',
        uid     => '2013',
        comment => 'Newrelic Monitoring Agent User',
        require => Group['newrelic'],
      }

      newrelic::package { 'newrelic-packages':
        packages => $packages,
        defaults => $defaults,
      }

      newrelic::config  { 'newrelic-configs':       configs => $configs }

      include newrelic::service

      Newrelic::Package[newrelic-packages]
      -> Newrelic::Config[newrelic-configs]

      if defined(Class[newrelic::service]) {
        Newrelic::Config[newrelic-configs] ~> Class[newrelic::service]
      }
    }
    false: {
      newrelic::package { 'newrelic-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'newrelic-package' |> {
        ensure => 'purged',
      }

    }
    # Do Nothing.
    default: {}
  }
}
