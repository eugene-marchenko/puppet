define initbuilder ( $inputfile )

{

    file { $inputfile:
        mode    => '0755',
        owner   => root,
        group   => root,
        ensure  => present,
        path    => '/etc/init.d/sec',
        content => template('sec/init.erb'),
    }

}

