# define resolver::config
node 'resolver-config-default' {
  include resolver::params
  resolver::config { 'resolver-configs' :
    configs => $resolver::params::resolver_configs,
  }
}

node 'resolver-config-from-facts' {
  include resolver::params
  resolver::config { 'resolver-configs' :
    configs => $resolver::params::resolver_configs,
  }
}

node 'resolver-config-no-params' {
  resolver::config { 'resolver-configs' : }
}

# class resolver
node 'class-resolver-default' {
  include resolver
}

node 'class-resolver-uninstalled' {
  class { 'resolver' : installed => false }
}
