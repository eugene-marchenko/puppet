# define logwatch::package
node 'logwatch-package-default' {
  include logwatch::params
  logwatch::package { 'logwatch-packages':
    packages => $logwatch::params::logwatch_packages,
    defaults => $logwatch::params::logwatch_package_defaults,
  }
}

node 'logwatch-package-no-params' {
  logwatch::package { 'logwatch-packages': }
}

# class logwatch

node 'class-logwatch-default' {
  include logwatch
}

node 'class-logwatch-uninstalled' {
  class { 'logwatch' : installed => false }
}

node 'class-logwatch-installed-invalid' {
  class { 'logwatch' : installed => yes }
}
