# define shells::config
node 'shells-config-default' {
  include shells::params
  shells::config { 'shells-configs' :
    configs => $shells::params::shells_configs,
  }
}

node 'shells-config-from-facts' {
  include shells::params
  shells::config { 'shells-configs' :
    configs => $shells::params::shells_configs,
  }
}

node 'shells-config-no-params' {
  shells::config { 'shells-configs' : }
}

# class shells
node 'class-shells-default' {
  include shells
}

node 'class-shells-uninstalled' {
  class { 'shells' : installed => false }
}
