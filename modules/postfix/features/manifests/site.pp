# define postfix::package
node 'postfix-package-default' {
  include postfix::params
  postfix::package { 'postfix-packages' :
    packages => $postfix::params::postfix_packages,
    defaults => $postfix::params::postfix_package_defaults,
  }
}

node 'postfix-package-no-params' {
  postfix::package { 'postfix-packages' : }
}

# define postfix::config
node 'postfix-config-default' {
  include postfix::params
  postfix::config { 'postfix-configs' :
    configs => $postfix::params::postfix_configs,
  }
}

node 'postfix-config-from-facts' {
  include postfix::params
  postfix::config { 'postfix-configs' :
    configs => $postfix::params::postfix_configs,
  }
}

node 'postfix-config-no-params' {
  postfix::config { 'postfix-configs' : }
}

# class postfix::service
node 'postfix-service-default' {
  include postfix::service
}

node 'postfix-service-uninstalled' {
  class { 'postfix::service' : installed  => false }
}

# Postfix::Mailalias nodes
node 'define-mailalias-one-alias' {
  postfix::mailalias { 'root' : recipient => 'webops@thedailybeast.com' }
}

node 'define-mailalias-multiple-alias' {
  postfix::mailalias { 'root' : recipient => 'webops@thedailybeast.com' }
  postfix::mailalias { 'foo' :  recipient => 'webops@thedailybeast.com' }
}

node 'define-mailalias-alias-absent' {
  postfix::mailalias { 'root' :
    ensure    => false,
    recipient => 'webops@thedailybeast.com'
  }
}

node 'define-mailalias-should-fail' {
  postfix::mailalias { 'root' : }
}

# class postfix
node 'class-postfix-default' {
  include postfix
}

node 'class-postfix-uninstalled' {
  class { 'postfix' : installed => false }
}
