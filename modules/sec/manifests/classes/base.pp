class sec::base  {

    file { '/etc/sec': ensure => directory }

    file { $sec_logfiles:
        mode    => '0755',
        owner   => root,
        group   => root,
        ensure  => present,
        path    => '/etc/init.d/sec',
        content => template('sec/init.erb'),
    }

    file { 'sec':
        mode   => '0755',
        owner  => root,
        group  => root,
        ensure => present,
        path   => '/usr/local/bin/sec',
        source => 'puppet:///modules/sec/sec'
    }

    file { 'mailsend':
        mode   => '0755',
        owner  => root,
        group  => root,
        ensure => present,
        path   => '/usr/local/bin/mailsend.sh',
        source => 'puppet:///modules/sec/mailsend.sh'
    }

}
