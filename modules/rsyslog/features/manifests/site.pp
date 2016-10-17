# define rsyslog::package
node 'rsyslog-package-default' {
  include rsyslog::params
  rsyslog::package { 'rsyslog-packages' :
    packages => $rsyslog::params::rsyslog_packages,
    defaults => $rsyslog::params::rsyslog_package_defaults,
  }
}

node 'rsyslog-package-no-params' {
  rsyslog::package { 'rsyslog-packages' : }
}

# define rsyslog::config
node 'rsyslog-config-default' {
  include rsyslog::params
  rsyslog::config { 'rsyslog-configs' :
    configs => $rsyslog::params::rsyslog_configs,
  }
}

node 'rsyslog-config-no-params' {
  rsyslog::config { 'rsyslog-configs' : }
}

# define rsyslog::config::file
node 'rsyslog-config-file' {
  rsyslog::config::file { '01-imuxsock' :
    content => '$ModLoad imuxsock',
  }
  rsyslog::config::file { '02-imklog' :
    content => '$ModLoad imklog',
  }
}

node 'rsyslog-config-file-no-params' {
  rsyslog::config::file { 'rsyslog-config-file' : }
}

# define rsyslog::config::selector
node 'rsyslog-config-selector' {
  rsyslog::config::selector { '55-catch-all' :
    selector    => '*.*',
    destination => '/var/log/syslog',
    comment     => 'This is the catch all for all non-discarded logs'
  }
  rsyslog::config::selector { '54-mail-no-discard' :
    selector    => 'mail.*',
    destination => '/var/log/mail.log',
    discard     => false,
  }
}

node 'rsyslog-config-selector-no-params' {
  rsyslog::config::selector { 'rsyslog-config-selector' : }
}

# define rsyslog::config::property
node 'rsyslog-config-property' {
  rsyslog::config::property { '55-varnish' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => '[varnishncsa]',
    destination => '@syslog.example.com',
  }
  rsyslog::config::property { '54-all-errors-no-discard' :
    property    => ':msg',
    comparison  => 'contains',
    value       => 'error',
    destination => '/var/log/error.log',
    comment     => 'Let\'s grab all errors out to a specific log file but keep them for other filters',
    discard     => false,
  }
}

node 'rsyslog-config-property-no-params' {
  rsyslog::config::property { 'rsyslog-config-property' : }
}

# define rsyslog::service
node 'rsyslog-service-default' {
  include rsyslog::service
}

node 'rsyslog-service-uninstalled' {
  class { 'rsyslog::service' : installed => false }
}

# class rsyslog
node 'class-rsyslog-default' {
  include rsyslog
}

node 'class-rsyslog-example-use-with-varnish' {
  include rsyslog
  # Set to 40 since 50-default will capture varnishncsa logs unless we discard in a file loaded before it
  rsyslog::config::property { '40-varnish' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => '[varnishncsa]',
    destination => '@syslog.example.com',
  }
}

node 'class-rsyslog-uninstalled' {
  class { 'rsyslog' : installed => false }
}

node 'class-rsyslog-server-central-logging-varnish-example' {
  $rsyslog_enable_udp = 'yes'
  include rsyslog
  rsyslog::config::property { '39-varnish-ncsa' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => '[varnishncsa]',
    destination => '/d0/logs/varnish/varnishncsa.log;NCSA',
    discard     => false,
  }
  rsyslog::config::property { '40-varnish' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => '[varnishncsa]',
    destination => '/d0/logs/varnish/varnish-syslog-traditional.log',
  }
  Class[rsyslog]                              -> Rsyslog::Config::Property[39-varnish-ncsa]
  Rsyslog::Config::Property[39-varnish-ncsa]  -> Rsyslog::Config::Property[40-varnish]
}
