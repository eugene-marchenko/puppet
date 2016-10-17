# define cron::package
node 'cron-package-default' {
  include cron::params
  cron::package { 'cron-packages' :
    packages => $cron::params::cron_packages,
    defaults => $cron::params::cron_package_defaults,
  }
}

node 'cron-package-no-params' {
  cron::package { 'cron-packages' : }
}

# define cron::config
node 'cron-config-default' {
  include cron::params
  cron::config { 'cron-configs' :
    configs => $cron::params::cron_configs,
  }
}

node 'cron-config-from-facts' {
  include cron::params
  cron::config { 'cron-configs' :
    configs => $cron::params::cron_configs,
  }
}

node 'cron-config-no-params' {
  cron::config { 'cron-configs' : }
}

# define cron::service
node 'cron-service-default' {
  include cron::service
}

node 'cron-service-uninstalled' {
  class { 'cron::service' : installed => false }
}

# class cron
node 'class-cron-default' {
  include cron
}

node 'class-cron-uninstalled' {
  class { 'cron' : installed => false }
}

# define cron::crontab
node 'cron-crontab-default' {
  cron::crontab { 'remove_backups':
    command => 'find /opt/backups -type f -mtime +7 | xargs rm -f'
  }
}

node 'cron-crontab-removed' {
  cron::crontab { 'remove_backups':
    installed => false,
    command   => 'find /opt/backups -type f -mtime +7 | xargs rm -f'
  }
}

node 'cron-crontab-disabled' {
  cron::crontab { 'remove_backups':
    enabled => false,
    command => 'find /opt/backups -type f -mtime +7 | xargs rm -f'
  }
}

node 'cron-crontab-options' {
  cron::crontab { 'remove_backups':
    command      => 'find /opt/backups -type f -mtime +7 | xargs rm -f',
    minute       => '*/5',
    hour         => '1',
    day_of_month => '1',
    month        => '2',
    day_of_week  => '1',
    user         => 'foobar',
    comment      => 'just testing',
    environment  => 'PATH=/usr/sbin:/usr/bin:/sbin:/bin',
  }
}

node 'cron-crontab-no-params' {
  cron::crontab { 'remove_backups': }
}
