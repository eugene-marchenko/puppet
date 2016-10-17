# define w3pw::package
node 'w3pw-package-default' {
  include w3pw::params
  w3pw::package { 'w3pw-packages' :
    packages => $w3pw::params::w3pw_packages,
    defaults => $w3pw::params::w3pw_package_defaults,
  }
}

node 'w3pw-package-no-params' {
  w3pw::package { 'w3pw-packages' : }
}

# define w3pw::config
node 'w3pw-config-default' {
  include w3pw::params
  w3pw::config { 'w3pw-configs' :
    configs => $w3pw::params::w3pw_configs,
  }
}

node 'w3pw-config-no-params' {
  w3pw::config { 'w3pw-configs' : }
}

# class w3pw
node 'class-w3pw-default' {
  include w3pw
}

node 'class-w3pw-uninstalled' {
  class { 'w3pw' : installed => false }
}
