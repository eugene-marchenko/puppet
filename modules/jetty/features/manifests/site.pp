# define jetty::package
node 'jetty-package-default' {
  include jetty::params
  jetty::package { 'jetty-packages' :
    packages => $jetty::params::jetty_packages,
    defaults => $jetty::params::jetty_package_defaults,
  }
}

node 'jetty-package-no-params' {
  jetty::package { 'jetty-packages' : }
}

# define jetty::config
node 'jetty-config-default' {
  include jetty::params
  jetty::config { 'jetty-configs' :
    configs => $jetty::params::jetty_configs,
  }
}

node 'jetty-config-no-params' {
  jetty::config { 'jetty-configs' : }
}

# define jetty::service
node 'jetty-service-default' {
  class { 'jetty::service' : }
}

node 'jetty-service-uninstalled' {
  class { 'jetty::service' : installed => false }
}

# define jetty::webapp
node 'jetty-webapp-web' {
  include jetty
  jetty::webapp { 'zapcat':
    config  => "jetty/Ubuntu/${::lsbdistcodename}/jetty-jmx.xml",
    warfile => 'http://bootstrap.ec2.thedailybeast.com/public/zapcat/zapcat-1.2.war',
  }
  jetty::webapp { 'custom':
    config  => 'http://google.com/foo.html',
    warfile => 'puppet:///modules/jetty/some/warfile.war',
  }
}

node 'jetty-webapp-webssl' {
  jetty::webapp { 'zapcat':
    config  => "jetty/Ubuntu/${::lsbdistcodename}/jetty-jmx.xml",
    warfile => 'https://bootstrap.ec2.thedailybeast.com.s3.amazonaws.com/public/zapcat/zapcat-1.2.war',
  }
}

node 'jetty-webapp-filebucket' {
  jetty::webapp { 'custom-webapp':
    config  => 'puppet:///modules/jetty/some/config.xml',
    warfile => 'puppet:///modules/jetty/some/warfile.war',
  }
}

node 'jetty-webapp-disabled' {
  jetty::webapp { 'custom-webapp':
    enable  => false,
    config  => 'puppet:///modules/jetty/some/config.xml',
    warfile => 'puppet:///modules/jetty/some/warfile.war',
  }
}

node 'jetty-webapp-uninstalled' {
  jetty::webapp { 'custom-webapp':
    installed => false,
    enable    => false,
    config    => 'puppet:///modules/jetty/some/config.xml',
    warfile   => 'puppet:///modules/jetty/some/warfile.war',
  }
}

node 'jetty-webapp-invalid-http' {
  jetty::webapp { 'custom-webapp':
    config  => 'httpss://somehost.com/some/path.html',
    warfile => 'puppet:///modules/jetty/some/warfile.war',
  }
}

node 'jetty-webapp-no-params' {
  jetty::webapp { 'custom-webapp': }
}

# class jetty
node 'class-jetty-default' {
  include jetty
  include jetty::service
  Class[jetty] ~> Class[jetty::service]
}

node 'class-jetty-uninstalled' {
  class { 'jetty' : installed => false }
}

# complex jetty install
node 'class-jetty-complex' {
  include jetty
  include jetty::service
  jetty::webapp { 'zapcat' :
    config  => 'jetty/Ubuntu/precise/jetty-jmx.xml',
    warfile => 'http://bootstrap.ec2.thedailybeast.com/public/zapcat/zapcat-1.2.war',
  }
  Class[jetty]          -> Jetty::Webapp[zapcat]
  Class[jetty]          ~> Class[jetty::service]
  Jetty::Webapp[zapcat] ~> Class[jetty::service]
}
