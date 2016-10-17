class puppet::master(
  $packages = hiera('puppet_master_packages'),
  $defaults = hiera('puppet_master_package_defaults'),
  $configs  = hiera('puppet_master_configs'),
  $services = hiera('puppet_master_services'),
  $remove   = false,
) inherits puppet::params {

  include stdlib

  validate_bool($remove)
  validate_hash($packages,$defaults,$configs,$services)

  if $remove {
    # Declare class
    puppet::package { 'puppet-master':
      packages => $packages,
      defaults => $defaults,
    }
    # Remove packages
    Package <| tag == 'puppet-master-package' |> {
      ensure => 'purged',
    }
    # Anchor it
    anchor{'puppet::master::begin':}  -> Puppet::Package[puppet-master]
    Puppet::Package[puppet-master]    -> anchor{'puppet::master::end':}
  } else {
    # Declare classes
    puppet::package { 'puppet-master':
      packages => $packages,
      defaults => $defaults,
    }
    puppet::config { 'puppet-master-configs':
      configs => $configs,
    }
    puppet::service { 'puppet-master-services':
      services  => $services
    }
    # Anchor them
    anchor{'puppet::master::begin':}        -> Puppet::Package[puppet-master]
    Puppet::Package[puppet-master]          -> Puppet::Config[puppet-master-configs]
    Puppet::Config[puppet-master-configs]   -> Puppet::Service[puppet-master-services]
    Puppet::Service[puppet-master-services] -> anchor{'puppet::master::end':}

    # Notify relationship
    Puppet::Config[puppet-master-configs] ~> Puppet::Service[puppet-master-services]
  }
}
