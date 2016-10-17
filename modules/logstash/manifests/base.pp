class logstash::base  {

    package { 'logstash':
        ensure => present,
    }

    file { '/etc/logstash':
        ensure     => directory,
    }

    file { '/etc/logstash/conf.d':
        ensure     => directory,
    }

    file { '/etc/logstash/patterns':
        ensure     => directory,
    }

    file { 'logstash-init':
        mode   => '0755',
        owner  => root,
        group  => root,
        ensure => present,
        path   => '/etc/init.d/logstash',
        source => 'puppet:///modules/logstash/logstash.init'
    }

    file { 'logstash':
        ensure => present,
        path   => '/usr/share/logstash/logstash.jar',
    }

    file { 'shipper-output':
        mode    => '0644',
        owner   => root,
        group   => root,
        ensure  => present,
        path    => '/etc/logstash/conf.d/shipper-output.conf',
        content => template('logstash/shipper-output.conf.erb'),
    }

    file { 'grok-patterns':
        mode   => '0644',
        owner  => root,
        group  => root,
        ensure => present,
        path   => '/etc/logstash/patterns/grok-patterns',
        source => 'puppet:///modules/logstash/patterns/grok-patterns'
    }

    file { 'linux-syslog':
        mode   => '0644',
        owner  => root,
        group  => root,
        ensure => present,
        path   => '/etc/logstash/patterns/linux-syslog',
        source => 'puppet:///modules/logstash/patterns/linux-syslog'
    }

    service { 'logstash':
        name       => 'logstash',
        ensure     => running,
        enable     => true,
        pattern    => 'logstash.jar',
        hasrestart => true,
        require    => Package['logstash'],
    }

}
