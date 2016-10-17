# define logrotate::package
node 'logrotate-package-default' {
  include logrotate::params
  logrotate::package { 'logrotate-packages' :
    packages => $logrotate::params::logrotate_packages,
    defaults => $logrotate::params::logrotate_package_defaults,
  }
}

node 'logrotate-package-no-params' {
  logrotate::package { 'logrotate-packages' : }
}

# define logrotate::config
node 'logrotate-config-default' {
  include logrotate::params
  logrotate::config { 'logrotate-configs' :
    configs => $logrotate::params::logrotate_configs,
  }
}

node 'logrotate-config-from-facts' {
  include logrotate::params
  logrotate::config { 'logrotate-configs' :
    configs => $logrotate::params::logrotate_configs,
  }
}

node 'logrotate-config-no-params' {
  logrotate::config { 'logrotate-configs' : }
}

# define logrotate::service
node 'logrotate-service-default' {
  include logrotate::params
  logrotate::service { 'logrotate-services' :
    services => $logrotate::params::logrotate_services,
  }
}

node 'logrotate-service-no-params' {
  logrotate::package { 'logrotate-services' : }
}

# class logrotate
node 'class-logrotate-default' {
  include logrotate
}

node 'class-logrotate-uninstalled' {
  class { 'logrotate' : installed => false }
}

# define logrotate::rule
node 'logrotate-rule-rotate-weekly' {
  logrotate::rule { 'web-server':
    path         => '/var/log/web-server.log',
    rotate_every => 'week',
  }
}

node 'logrotate-rule-webserver-removed' {
  logrotate::rule { 'web-server':
    path      => '/var/log/web-server.log',
    installed => false,
  }
}

node 'logrotate-rule-no-params' {
  logrotate::rule { 'web-server': }
}

node 'logrotate-rule-every-param' {
  logrotate::rule { 'web-server':
    path            => [ '/var/log/web-server-error.log',
                        '/var/log/web-server.log',
                      ],
    compress        => true,
    compresscmd     => '/bin/gzip',
    compressext     => 'foo',
    compressoptions => '-9',
    copy            => true,
    copytruncate    => true,
    create          => true,
    create_mode     => '0644',
    create_owner    => 'root',
    create_group    => 'root',
    dateext         => true,
    dateformat      => 'YYYYmmdd',
    delaycompress   => true,
    extension       => 'foo',
    ifempty         => true,
    mail            => 'sa@example.com',
    mailfirst       => true,
    maxage          => '90',
    minsize         => '1G',
    missingok       => true,
    olddir          => 'old',
    postrotate      => 'reload web-server',
    prerotate       => 'run-parts /etc/logrotate.d/web-server-prerotate',
    firstaction     => 'echo "Starting log rotation" > /tmp/foo',
    lastaction      => 'echo "Completed log rotation" > /tmp/foo',
    rotate          => '7',
    rotate_every    => 'day',
    size            => '1G',
    sharedscripts   => true,
    shred           => true,
    shredcycles     => '2',
    start           => '1',
    uncompresscmd   => 'gunzip',
  }

  logrotate::rule { 'web-server2':
    path            => [ '/var/log/web-server-error2.log',
                        '/var/log/web-server2.log',
                      ],
    compress        => false,
    compresscmd     => '/bin/gzip',
    compressext     => 'foo',
    compressoptions => '-9',
    copy            => false,
    copytruncate    => false,
    create          => false,
    dateext         => false,
    dateformat      => 'YYYYmmdd',
    delaycompress   => false,
    extension       => 'foo',
    ifempty         => false,
    mail            => 'sa@example.com',
    mailfirst       => false,
    maxage          => '90',
    minsize         => '1G',
    missingok       => false,
    olddir          => 'old',
    postrotate      => 'reload web-server',
    prerotate       => 'run-parts /etc/logrotate.d/web-server-prerotate',
    firstaction     => 'echo "Starting log rotation" > /tmp/foo',
    lastaction      => 'echo "Completed log rotation" > /tmp/foo',
    rotate          => '7',
    rotate_every    => 'day',
    size            => '1G',
    sharedscripts   => false,
    shred           => false,
    shredcycles     => '2',
    start           => '1',
    uncompresscmd   => 'gunzip',
  }
}

node 'logrotate-rule-invalid-namevar' {
  logrotate::rule { '^%$' : path => '/var/log/foo' }
}

node 'logrotate-rule-invalid-compress' {
  logrotate::rule { 'foo' : path => '/var/log/foo', compress => 'foo' }
}

node 'logrotate-rule-invalid-copy' {
  logrotate::rule { 'foo' : path => '/var/log/foo', copy => 'foo' }
}

node 'logrotate-rule-invalid-copytruncate' {
  logrotate::rule { 'foo' : path => '/var/log/foo', copytruncate=> 'foo' }
}

node 'logrotate-rule-invalid-create' {
  logrotate::rule { 'foo' : path => '/var/log/foo', create => 'foo' }
}

node 'logrotate-rule-invalid-delaycompress' {
  logrotate::rule { 'foo' : path => '/var/log/foo', delaycompress => 'foo' }
}

node 'logrotate-rule-invalid-dateext' {
  logrotate::rule { 'foo' : path => '/var/log/foo', dateext => 'foo' }
}

node 'logrotate-rule-invalid-missingok' {
  logrotate::rule { 'foo' : path => '/var/log/foo', missingok => 'foo' }
}

node 'logrotate-rule-invalid-sharedscripts' {
  logrotate::rule { 'foo' : path => '/var/log/foo', sharedscripts => 'foo' }
}

node 'logrotate-rule-invalid-shred' {
  logrotate::rule { 'foo' : path => '/var/log/foo', shred => 'foo' }
}

node 'logrotate-rule-invalid-ifempty' {
  logrotate::rule { 'foo' : path => '/var/log/foo', ifempty => 'foo' }
}

node 'logrotate-rule-invalid-rotate_every' {
  logrotate::rule { 'foo' : path => '/var/log/foo', rotate_every => 'foo' }
}

node 'logrotate-rule-invalid-maxage' {
  logrotate::rule { 'foo' : path => '/var/log/foo', maxage => 'foo' }
}

node 'logrotate-rule-invalid-minsize' {
  logrotate::rule { 'foo' : path => '/var/log/foo', minsize => '1g' }
}

node 'logrotate-rule-invalid-rotate' {
  logrotate::rule { 'foo' : path => '/var/log/foo', rotate => 'foo' }
}

node 'logrotate-rule-invalid-size' {
  logrotate::rule { 'foo' : path => '/var/log/foo', size => '1g' }
}

node 'logrotate-rule-invalid-shredcycles' {
  logrotate::rule { 'foo' : path => '/var/log/foo', shredcycles => 'foo' }
}

node 'logrotate-rule-invalid-start' {
  logrotate::rule { 'foo' : path => '/var/log/foo', start => 'foo' }
}

node 'logrotate-rule-invalid-mailfirst' {
  logrotate::rule { 'foo' :
    path      => '/var/log/foo',
    mailfirst => true,
    maillast  => true,
  }
}

node 'logrotate-rule-invalid-create_group' {
  logrotate::rule { 'foo' : path => '/var/log/foo', create_group => 'foo' }
}

node 'logrotate-rule-invalid-create_owner' {
  logrotate::rule { 'foo' : path => '/var/log/foo', create_owner => 'foo' }
}

node 'logrotate-rule-invalid-create_mode' {
  logrotate::rule { 'foo' : path => '/var/log/foo', create_mode => 'foo' }
}
