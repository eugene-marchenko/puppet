class sec::initscript  {

    exec { 'sec_register':
        require => File['/etc/init.d/sec'],
        command => 'update-rc.d sec defaults',
        creates => '/etc/rc2.d/S20sec',
    }

    service { 'sec':
        name       => 'sec',
        ensure     => running,
        enable     => true,
        pattern    => '/usr/local/bin/sec',
        hasrestart => true,
        require    => [ Exec['sec_register'], File['mailsend'], ],
    }
}
