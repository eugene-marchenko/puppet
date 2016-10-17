# define varnish::package
node 'varnish-package-default' {
  include varnish::params
  varnish::package { 'varnish-packages' :
    packages => $varnish::params::varnish_packages,
    defaults => $varnish::params::varnish_package_defaults,
  }
}

node 'varnish-package-no-params' {
  varnish::package { 'varnish-packages' : }
}

# define varnish::config
node 'varnish-config-default' {
  include varnish::params
  varnish::config { 'varnish-vcl-configs' :
    configs => $varnish::params::varnish_vcls,
  }
  varnish::config { 'varnish-configs' :
    configs => $varnish::params::varnish_configs,
  }
  varnish::config { 'varnish-log-configs' :
    configs => $varnish::params::varnish_log_configs,
  }
  varnish::config { 'varnish-init-scripts' :
    configs => $varnish::params::varnish_init_configs,
}

}

node 'varnish-config-no-params' {
  varnish::config { 'varnish-configs' : }
}

# define varnish::service
node 'varnish-service-default' {
  include varnish::newrelic_service
  include varnish::service
  include varnish::log::service
}

node 'varnish-service-uninstalled' {
  class { 'varnish::service'      : installed  => false }
  class { 'varnish::log::service' : installed  => false }
}

# class varnish
node 'class-varnish-default' {
  include varnish
}

node 'class-varnish-uninstalled' {
  class { 'varnish' : installed => false }
}
