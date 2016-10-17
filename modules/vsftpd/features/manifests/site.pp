# define vsftpd::package
node 'vsftpd-package-default' {
  include vsftpd::params
  vsftpd::package { 'vsftpd-packages' :
    packages => $vsftpd::params::vsftpd_packages,
    defaults => $vsftpd::params::vsftpd_package_defaults,
  }
}

node 'vsftpd-package-no-params' {
  vsftpd::package { 'vsftpd-packages' : }
}

# define vsftpd::config
node 'vsftpd-config-default' {
  include vsftpd::params
  vsftpd::config { 'vsftpd-configs' :
    configs => $vsftpd::params::vsftpd_configs,
  }
}

node 'vsftpd-config-from-facts' {
  include vsftpd::params
  vsftpd::config { 'vsftpd-configs' :
    configs => $vsftpd::params::vsftpd_configs,
  }
}

node 'vsftpd-config-no-params' {
  vsftpd::config { 'vsftpd-configs' : }
}

# define vsftpd::service
node 'vsftpd-service-default' {
  include vsftpd::service
}

node 'vsftpd-service-uninstalled' {
  class { 'vsftpd::service' : installed => false }
}

# class vsftpd
node 'class-vsftpd-default' {
  include vsftpd
}

node 'class-vsftpd-uninstalled' {
  class { 'vsftpd' : installed => false }
}
