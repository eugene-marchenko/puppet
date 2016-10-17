# define sasl::package
node 'sasl-package-default' {
  include sasl::params
  sasl::package { 'sasl-packages' :
    packages => $sasl::params::sasl_packages,
    defaults => $sasl::params::sasl_package_defaults,
  }
}

node 'sasl-package-no-params' {
  sasl::package { 'sasl-packages' : }
}

# define sasl::config
node 'sasl-config-default' {
  include sasl::params
  sasl::config { 'sasl-configs' :
    configs => $sasl::params::sasl_configs,
  }
}

node 'sasl-config-from-facts' {
  include sasl::params
  sasl::config { 'sasl-configs' :
    configs => $sasl::params::sasl_configs,
  }
}

node 'sasl-config-postfix-chroot' {
  include sasl::params
  sasl::config { 'sasl-configs' :
    configs => $sasl::params::sasl_configs,
  }
}

node 'sasl-config-no-params' {
  sasl::config { 'sasl-configs' : }
}

# class sasl::service
node 'sasl-service-default' {
  include sasl::service
}

node 'sasl-service-uninstalled' {
  class { 'sasl::service' : installed => false }
}

# define sasl::user
node 'define-sasl-user-add-default' {
  sasl::user { 'relay' : password => 's3cur3' }
}

node 'define-sasl-user-remove-default' {
  sasl::user { 'relay' : ensure => false, password => 's3cur3' }
}

node 'define-sasl-user-add-with-domain-and-file' {
  sasl::user { 'relay' :
    password  => 's3cur3',
    mx_domain => 'relay.example.com',
  }
}

node 'define-sasl-user-remove-with-domain-and-file' {
  sasl::user { 'relay' :
    ensure    => false,
    password  => 's3cur3',
    mx_domain => 'relay.example.com',
  }
}

# class sasl
node 'class-sasl-default' {
  include sasl
}

node 'class-sasl-postfix-installed' {
  include postfix
  include sasl
}

node 'class-sasl-uninstalled' {
  include postfix
  class { 'sasl' : installed => false }
}
