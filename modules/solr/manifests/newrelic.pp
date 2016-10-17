class solr::newrelic(
  $solr_cores_config = $solr::params::solr_cores_config
) inherits solr::params {
  include roles::packages

  exec {'download newrelic agent':
    command => '/usr/bin/wget -q https://oss.sonatype.org/content/repositories/releases/com/newrelic/agent/java/newrelic-java/3.26.1/newrelic-java-3.26.1.zip -O /usr/share/jetty/newrelic.zip',
    notify  => Exec['unzip_package'],
    require => File['create_jetty_dir'],
    creates => '/usr/share/jetty/newrelic.zip',
  }

  exec { 'unzip_package':
    command     => 'unzip /usr/share/jetty/newrelic.zip -d /usr/share/jetty/',
    cwd         => '/usr/share/jetty/',
    user        => 'root',
    require     => Exec['download newrelic agent'],
    refreshonly => true,
    notify      => File['create_log_dir'],
  }

  file {'create_log_dir':
    ensure  => 'directory',
    path    => '/usr/share/jetty/newrelic/logs',
    mode    => '1777',
    owner   => 'root',
    group   => 'root',
    require => Exec['unzip_package'],
    notify  => Class[jetty::service],
  }

  file {'create_jetty_dir':
    ensure  => 'directory',
    path    => '/usr/share/jetty',
    mode    => '1777',
    owner   => 'root',
    group   => 'root',
    require => Package['unzip'],
    notify  => Exec['download newrelic agent'],
  }

  file { '/usr/share/jetty/newrelic/newrelic.yml' :
    ensure  => 'present',
    path    => '/usr/share/jetty/newrelic/newrelic.yml',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('solr/newrelic_config/newrelic.yml.erb'),
    require => Exec['unzip_package'],
  }
}
