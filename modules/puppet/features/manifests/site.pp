# define puppet::package
node 'define-puppet-package-from-params' {
  include puppet::params
  puppet::package { 'puppet-packages':
    packages => $puppet::params::puppet_client_packages,
    defaults => $puppet::params::puppet_client_package_defaults,
  }
}

node 'define-puppet-package-no-params' {
  puppet::package { 'puppet-packages': }
}

# define puppet::config
node 'define-puppet-config-from-params' {
  include puppet::params
  puppet::config { 'puppet-configs':
    configs => $puppet::params::puppet_client_configs
  }
}

node 'define-puppet-config-from-facts' {
  include puppet::params
  puppet::config { 'puppet-configs':
    configs => $puppet::params::puppet_client_configs
  }
}

node 'define-puppet-config-no-params' {
  puppet::config { 'puppet-configs': }
}

# define puppet::service
node 'define-puppet-service-from-params' {
  include puppet::params
  puppet::service { 'puppet-services':
    services => $puppet::params::puppet_client_services
  }
}

node 'define-puppet-service-no-params' {
  puppet::service { 'puppet-services': }
}

# class puppet::client
node 'class-puppet-client-default' {
  include puppet::client
}

node 'class-puppet-client-removed' {
  class { 'puppet::client': remove => true }
}

node 'class-puppet-client-invalid-packages-param' {
  class { 'puppet::client': packages => 'foo' }
}

node 'class-puppet-client-invalid-defaults-param' {
  class { 'puppet::client': defaults => 'foo' }
}

node 'class-puppet-client-invalid-configs-param' {
  class { 'puppet::client': configs => 'foo' }
}

node 'class-puppet-client-invalid-services-param' {
  class { 'puppet::client': services => 'foo' }
}

node 'class-puppet-client-invalid-remove-param' {
  class { 'puppet::client': remove => 'foo' }
}

# class puppet::master
node 'class-puppet-master-default' {
  include puppet::master
}

node 'class-puppet-master-removed' {
  class { 'puppet::master': remove => true }
}

node 'class-puppet-master-invalid-packages-param' {
  class { 'puppet::master': packages => 'foo' }
}

node 'class-puppet-master-invalid-defaults-param' {
  class { 'puppet::master': defaults => 'foo' }
}

node 'class-puppet-master-invalid-configs-param' {
  class { 'puppet::master': configs => 'foo' }
}

node 'class-puppet-master-invalid-services-param' {
  class { 'puppet::master': services => 'foo' }
}

node 'class-puppet-master-invalid-remove-param' {
  class { 'puppet::master': remove => 'foo' }
}

# class puppet
node 'class-puppet-default' {
  include puppet
}

node 'class-puppet-with-master' {
  class { 'puppet' : master => true }
}

node 'class-puppet-client-master-removed' {
  class { 'puppet' : client => false, master => false }
}
