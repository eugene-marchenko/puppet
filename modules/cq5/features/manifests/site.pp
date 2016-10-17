# define cq5::config
node 'cq5-config-default' {
  include cq5::params
  cq5::config { 'cq5-configs' :
    configs => $cq5::params::cq5_configs,
  }
}

node 'cq5-config-no-params' {
  cq5::config { 'cq5-configs' : }
}

# class cq5
node 'class-cq5-default' {
  include cq5
}

node 'class-cq5-uninstalled' {
  class { 'cq5' : installed => false }
}

# define cq5::node
node 'cq5-node-simple' {
  cq5::node { 'author' :
    port => '8080',
    path => '/opt/cq5/author',
    env  => 'prod',
    role => 'author',
  }
}

node 'cq5-node-diff-jvm-params' {
  cq5::node { 'author' :
    enable    => false,
    port      => '4502',
    path      => '/opt/cq5/author-node1',
    mount     => '/opt/cq5/author-node1',
    env       => 'prod',
    role      => 'author',
    permgen   => 512,
    javaopts  => '-Dfoo',
    heap_max  => '1024',
    max_files => '1024',
  }
}

node 'cq5-node-no-gc-opts' {
  cq5::node { 'node1' :
    port              => '4502',
    path              => '/opt/cq5/node1',
    mount             => '/opt/cq5/node1',
    env               => 'prod',
    role              => 'publish',
    verbose_gc        => false,
    printgcdetails    => false,
    printgctimestamps => false,
  }
}

node 'cq5-node-diff-interface-java-home' {
  cq5::node { 'author-internal' :
    port      => '4502',
    path      => '/opt/cq5/author',
    mount     => '/opt/cq5/author',
    env       => 'qa',
    role      => 'author',
    interface => '127.0.0.1',
    javahome  => '/opt/java6',
  }
}

node 'cq5-node-uninstalled' {
  cq5::node { 'publish' :
    installed => false,
    port      => '8080',
    path      => '/opt/cq5/publish',
    mount     => '/opt/cq5/publish',
    env       => 'prod',
    role      => 'publish',
  }
}

node 'cq5-invalid-role' {
  cq5::node { 'invalid' :
    port => '4502',
    path => '/d0/invalid',
    env  => 'uat',
    role => 'foo',
  }
}

# class cq5::export
node 'cq5-export-default' {
  class { 'cq5::export' : }
}

node 'cq5-export-required-params' {
  class { 'cq5::export' : accesskey => 'FOO', secretkey => 'BAR' }
}

node 'cq5-export-from-source-diff-path' {
  class { 'cq5::export' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    path      => '/usr/bin/export.pl',
    source    => 'puppet:///modules/cq5/scripts/export.pl'
  }
}

node 'cq5-export-from-content' {
  class { 'cq5::export' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    content   => 'foo',
  }
}

node 'cq5-export-uninstalled' {
  class { 'cq5::export' :
    installed => false,
    accesskey => 'FOO',
    secretkey => 'BAR',
  }
}

# class cq5::datastoregc
node 'cq5-datastoregc-default' {
  class { 'cq5::datastoregc' : }
}

node 'cq5-datastoregc-from-source-diff-path' {
  class { 'cq5::datastoregc' :
    path   => '/usr/bin/datastoregc.pl',
    source => 'puppet:///modules/cq5/scripts/datastoregc.pl'
  }
}

node 'cq5-datastoregc-from-content' {
  class { 'cq5::datastoregc' :
    content   => 'foo',
  }
}

node 'cq5-datastoregc-uninstalled' {
  class { 'cq5::datastoregc' :
    installed => false,
  }
}

# class cq5::taropt
node 'cq5-taropt-default' {
  class { 'cq5::taropt' : }
}

node 'cq5-taropt-from-source-diff-path' {
  class { 'cq5::taropt' :
    path   => '/usr/bin/taropt.pl',
    source => 'puppet:///modules/cq5/scripts/taropt.pl'
  }
}

node 'cq5-taropt-from-content' {
  class { 'cq5::taropt' :
    content   => 'foo',
  }
}

node 'cq5-taropt-uninstalled' {
  class { 'cq5::taropt' :
    installed => false,
  }
}
