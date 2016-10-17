class puppet(
  $client                   = true,
  $master                   = false,
  $client_package_defaults  = hiera('puppet_client_package_defaults'),
  $master_package_defaults  = hiera('puppet_master_package_defaults'),
  $client_packages          = hiera('puppet_client_packages'),
  $master_packages          = hiera('puppet_master_packages'),
  $client_configs           = hiera('puppet_client_configs'),
  $master_configs           = hiera('puppet_master_configs'),
  $client_services          = hiera('puppet_client_services'),
  $master_services          = hiera('puppet_master_services'),
) inherits puppet::params {

  include stdlib

  validate_bool($client,$master)
  validate_hash($client_packages,$master_packages)
  validate_hash($client_package_defaults,$master_package_defaults)
  validate_hash($client_configs,$master_configs)
  validate_hash($client_services,$master_services)

  case $client {
    true: {
      class { 'puppet::client':
        packages => $client_packages,
        defaults => $client_package_defaults,
        configs  => $client_configs,
        services => $client_services,
      }
    }
    false: {
      class { 'puppet::client':
        packages => $client_packages,
        defaults => $client_package_defaults,
        configs  => $client_configs,
        services => $client_services,
        remove   => true,
      }
    }
    # Do nothing
    default: {}
  }

  case $master {
    true: {
      class { 'puppet::master':
        packages => $master_packages,
        defaults => $master_package_defaults,
        configs  => $master_configs,
        services => $master_services,
      }
    }
    false: {
      class { 'puppet::master':
        packages => $master_packages,
        defaults => $master_package_defaults,
        configs  => $master_configs,
        services => $master_services,
        remove   => true,
      }
    }
    # Do nothing
    default: {}
  }

  anchor {'puppet::begin':} -> Class[puppet::client]
  Class[puppet::client]     -> Class[puppet::master]
  Class[puppet::master]     -> anchor {'puppet::end':}
}
