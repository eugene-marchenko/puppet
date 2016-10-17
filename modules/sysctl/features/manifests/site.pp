# define sysctl::configure
node 'sysctl-option-net.core.rmem_max' {
  include sysctl
  sysctl::option { 'net.core.rmem_max' : value => '16777216' }
}

node 'sysctl-option-value-comment' {
  include sysctl
  sysctl::option { 'net.ipv4.ip_local_port_range' :
    value   => '1024 65535',
    comment => '# Per Varnish recommendations',
  }
}

# define sysctl::package
node 'sysctl-package-default' {
  include sysctl::params
  sysctl::package { 'sysctl-packages' :
    packages => $sysctl::params::sysctl_packages,
    defaults => $sysctl::params::sysctl_package_defaults,
  }
}

node 'sysctl-package-no-params' {
  sysctl::package { 'sysctl-packages' : }
}

# define sysctl::config
node 'sysctl-config-default' {
  include sysctl::params
  sysctl::config { 'sysctl-configs' :
    configs => $sysctl::params::sysctl_configs,
  }
}

node 'sysctl-config-from-facts' {
  include sysctl::params
  sysctl::config { 'sysctl-configs' :
    configs => $sysctl::params::sysctl_configs,
  }
}

node 'sysctl-config-no-params' {
  sysctl::config { 'sysctl-configs' : }
}

# define sysctl::service
node 'sysctl-service-default' {
  include sysctl::service
}

node 'sysctl-service-uninstalled' {
  class { 'sysctl::service' : installed => false }
}

# class sysctl
node 'class-sysctl-default' {
  include sysctl
}

node 'class-sysctl-uninstalled' {
  class { 'sysctl' : installed => false }
}

node 'sysctl-complex-install' {
  class { 'sysctl' : installed    => true }
  sysctl::option { 'foo' : value  => 65535 }
}
