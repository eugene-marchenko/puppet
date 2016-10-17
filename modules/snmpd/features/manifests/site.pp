# define snmpd::package
node 'snmpd-package-default' {
  include snmpd::params
  snmpd::package { 'snmpd-packages' :
    packages => $snmpd::params::snmpd_packages,
    defaults => $snmpd::params::snmpd_package_defaults,
  }
}

node 'snmpd-package-no-params' {
  snmpd::package { 'snmpd-packages' : }
}

# define snmpd::config
node 'snmpd-config-default' {
  include snmpd::params
  snmpd::config { 'snmpd-configs' :
    configs => $snmpd::params::snmpd_configs,
  }
}

node 'snmpd-config-no-params' {
  snmpd::config { 'snmpd-configs' : }
}

# define snmpd::service
node 'snmpd-service-default' {
  include snmpd::service
}

node 'snmpd-service-uninstalled' {
  class { 'snmpd::service' : installed => false }
}

# class snmpd
node 'class-snmpd-default' {
  include snmpd
}

node 'class-snmpd-uninstalled' {
  class { 'snmpd' : installed => false }
}
