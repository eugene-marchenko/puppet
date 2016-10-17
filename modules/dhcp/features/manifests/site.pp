# define dhcp::package
node 'dhcp-package-default' {
  include dhcp::params
  dhcp::package { 'dhcp-packages' :
    packages => $dhcp::params::dhcp_packages,
    defaults => $dhcp::params::dhcp_package_defaults,
  }
}

node 'dhcp-package-no-params' {
  dhcp::package { 'dhcp-packages' : }
}

# define dhcp::config
node 'dhcp-config-default' {
  include dhcp::params
  dhcp::config { 'dhcp-configs' :
    configs => $dhcp::params::dhcp_configs,
  }
}

node 'dhcp-config-from-facts' {
  include dhcp::params
  dhcp::config { 'dhcp-configs' :
    configs => $dhcp::params::dhcp_configs,
  }
}

# define dhcp::service
node 'dhcp-service-default' {
  include dhcp::service
}

node 'dhcp-service-uninstalled' {
  class { 'dhcp::service' : installed => false }
}

# class dhcp
node 'class-dhcp-default' {
  include dhcp
}

node 'class-dhcp-uninstalled' {
  class { 'dhcp' : installed => false }
}
