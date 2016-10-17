# define monit::monitor
node 'monit-monitor-service-puppet' {
  monit::monitor::service { 'puppetd' : initscript => '/etc/init.d/puppet' }
}

# define monit::package
node 'monit-package-default' {
  include monit::params
  monit::package { 'monit-packages' :
    packages => $monit::params::monit_packages,
    defaults => $monit::params::monit_package_defaults,
  }
}

node 'monit-package-no-params' {
  monit::package { 'monit-packages' : }
}

# define monit::config
node 'monit-config-default' {
  include monit::params
  monit::config { 'monit-configs' :
    configs => $monit::params::monit_configs,
  }
}

node 'monit-config-from-facts' {
  include monit::params
  monit::config { 'monit-configs' :
    configs => $monit::params::monit_configs,
  }
}

node 'monit-config-no-params' {
  monit::config { 'monit-configs' : }
}

# class monit::service
node 'monit-service-default' {
  include monit::service
}

node 'monit-service-uninstalled' {
  class { 'monit::service' : installed  => false }
}

# class monit
node 'class-monit-default' {
  include monit
}

node 'class-monit-uninstalled' {
  class { 'monit' : installed => false }
}

node 'monit-complex-install' {
  class { 'monit' : installed => true }
  monit::monitor::service { 'foo' : }
}

node 'monit-complex-install-invalid' {
  class { 'monit' : installed => false }
  monit::monitor::service { 'foo' : }
}
