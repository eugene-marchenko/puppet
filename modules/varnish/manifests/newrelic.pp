class varnish::newrelic(
) inherits varnish::params {
  include varnish::newrelic_service
  include roles::packages
  include roles::cq5::jvm

  file {'/usr/share/varnish/newrelic_plugin.zip':
    ensure  => 'present',
    notify  => Exec['unzip_varnish'],
    require => Package['unzip'],
    source  => 'puppet:///modules/varnish/newrelic_plugin.zip',
  }

  exec { 'unzip_varnish':
    command     => 'unzip /usr/share/varnish/newrelic_plugin.zip -d /usr/share/varnish/',
    cwd         => '/usr/share/varnish/',
    user        => 'root',
    require     => File['/usr/share/varnish/newrelic_plugin.zip'],
    refreshonly => true,
  }

  file { '/usr/share/varnish/newrelic_plugin/config/newrelic.json' :
    ensure  => 'present',
    path    => '/usr/share/varnish/newrelic_plugin/config/newrelic.json',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('varnish/newrelic_config/newrelic.json.erb'),
    require => Exec['unzip_varnish'],
    notify  => Class[varnish::newrelic_service],
  }

  file { '/usr/share/varnish/newrelic_plugin/config/logging.properties' :
    ensure  => 'present',
    path    => '/usr/share/varnish/newrelic_plugin/config/logging.properties',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('varnish/newrelic_config/logging.properties.erb'),
    require => Exec['unzip_varnish'],
    notify  => Class[varnish::newrelic_service],
  }

  file { '/usr/share/varnish/newrelic_plugin/config/plugin.json' :
    ensure  => 'present',
    path    => '/usr/share/varnish/newrelic_plugin/config/plugin.json',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('varnish/newrelic_config/plugin.json.erb'),
    require => Exec['unzip_varnish'],
    notify  => Class[varnish::newrelic_service],
  }

  file { '/etc/init.d/newrelic-varnish' :
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('varnish/init.d/newrelic-varnish.erb'),
    require => Package['openjdk-6-jdk'],
    notify  => Class[varnish::newrelic_service],
  }

  file { '/etc/init.d/newrelic_varnish' :
    ensure  => 'absent',
  }

}
