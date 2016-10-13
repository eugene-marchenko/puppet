# define hosts::configure
node 'hosts-manage-one-host' {
  hosts::manage { 'amazon' : ip => '169.254.169.254' }
}

node 'hosts-manage-aliases' {
  hosts::manage { 'server1.test.local' :
    ip           => '127.0.0.1',
    host_aliases => [ 'server1', 'srv1' ],
  }
}

node 'hosts-manage-with-comment' {
  hosts::manage { 'foo' :
    ip      => '127.0.0.1',
    comment => 'just testing',
  }
}

# define hosts::config
node 'hosts-config-default' {
  include hosts::params
  hosts::config { 'hosts-configs' :
    configs => $hosts::params::hosts_configs,
  }
}

node 'hosts-config-no-params' {
  hosts::config { 'hosts-configs' : }
}

# class hosts
node 'class-hosts-default' {
  include hosts
}

node 'class-hosts-uninstalled' {
  class { 'hosts' : installed => false }
}

node 'hosts-complex-install' {
  class { 'hosts' : installed     => true }
  hosts::manage { 'amazon' : ip   => '169.254.169.254' }
}
