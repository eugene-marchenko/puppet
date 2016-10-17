# define nw_analytics::package
node 'nw_analytics-package-default' {
  include nw_analytics::params
  nw_analytics::package { 'nw_analytics-packages' :
    packages => $nw_analytics::params::nw_analytics_packages,
    defaults => $nw_analytics::params::nw_analytics_package_defaults,
  }
}

node 'nw_analytics-package-no-params' {
  nw_analytics::package { 'nw_analytics-packages' : }
}

# define nw_analytics::config
node 'nw_analytics-config-default' {
  include nw_analytics::params
  nw_analytics::config { 'nw_analytics-configs' :
    configs => $nw_analytics::params::nw_analytics_configs,
  }
}

node 'nw_analytics-config-no-params' {
  nw_analytics::config { 'nw_analytics-configs' : }
}

# class nw_analytics
node 'class-nw_analytics-default' {
  include nw_analytics
}

node 'class-nw_analytics-uninstalled' {
  class { 'nw_analytics' : installed => false }
}
