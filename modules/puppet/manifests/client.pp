class puppet::client(
  $packages = hiera('puppet_client_packages'),
  $defaults = hiera('puppet_client_package_defaults'),
  $configs  = hiera('puppet_client_configs'),
  $services = hiera('puppet_client_services'),
  $remove   = false,
) inherits puppet::params {

  include stdlib

  validate_bool($remove)
  validate_hash($packages,$defaults,$configs,$services)

  if $remove {
    # Declare class
    puppet::package { 'puppet-client':
      packages => $packages,
      defaults => $defaults,
    }
    # Remove packages
    Package <| tag == 'puppet-client-package' |> {
      ensure => 'purged',
    }
    # Anchor it
    anchor{'puppet::client::begin':}  -> Puppet::Package[puppet-client]
    Puppet::Package[puppet-client]    -> anchor{'puppet::client::end':}
  } else {
    # Declare classes
    puppet::package { 'puppet-client':
      packages => $packages,
      defaults => $defaults,
    }
    puppet::config { 'puppet-client-configs':
      configs => $configs,
    }
    puppet::service { 'puppet-client-services':
      services  => $services
    }
    # Anchor them
    anchor{'puppet::client::begin':}        -> Puppet::Package[puppet-client]
    Puppet::Package[puppet-client]          -> Puppet::Config[puppet-client-configs]
    Puppet::Config[puppet-client-configs]   -> Puppet::Service[puppet-client-services]
    Puppet::Service[puppet-client-services] -> anchor{'puppet::client::end':}

    # Notify relationship
    Puppet::Config[puppet-client-configs] ~> Puppet::Service[puppet-client-services]
  }
}
