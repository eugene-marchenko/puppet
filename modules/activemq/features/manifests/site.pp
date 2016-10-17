# class activemq::packages
node 'class-activemq-packages-default' {
  include activemq::packages
}

node 'class-activemq-packages-uninstalled' {
  class { 'activemq::packages': installed => false }
}

# class activemq::configs
node 'class-activemq-configs-default' {
  include activemq::configs
}

node 'class-activemq-configs-uninstalled' {
  class { 'activemq::configs': installed => false }
}

# class activemq::services
node 'class-activemq-services-default' {
  include activemq::services
}

node 'class-activemq-services-disabled' {
  class { 'activemq::services' : enabled => false }
}

node 'class-activemq-services-stopped' {
  class { 'activemq::services' : running => false }
}

# class activemq
node 'class-activemq-default' {
  include activemq
}

node 'class-activemq-uninstalled' {
  class { 'activemq' : installed => false }
}

# define activemq::instance
node 'activemq-instance-test' {
  activemq::instance { 'foo' : }
  activemq::instance { 'bar' : enabled    => false }
  activemq::instance { 'baz' : installed  => false }
  activemq::instance { 'zaz' :
    min_heap  => '1024',
    max_heap  => '2048',
    base      => '/mnt/activemq/zaz',
    java_home => '/opt/java6/',
    args      => 'start xbean:foo.xml',
  }
  activemq::instance { 'lol' :
    config_content  => 'foo',
    log4j_content   => 'foo',
    options_content => 'foo',
  }
  activemq::instance { 'cat' :
    config_source  => 'puppet:///modules/foo/bar/activemq.xml',
    log4j_source   => 'puppet:///modules/foo/bar/log4j.properties',
    options_source => 'puppet:///modules/foo/bar/options',
  }
  activemq::instance { 'haz' :
    config_template  => 'activemq/Ubuntu/precise/default.erb',
    log4j_template   => 'activemq/Ubuntu/precise/default.erb',
    options_template => 'activemq/Ubuntu/precise/default.erb',
  }
}
