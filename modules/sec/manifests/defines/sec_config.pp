define sec::sec_config ( $pattern, $desc )

{
    #Just for readability
    $filename = $title

    file { "/etc/sec/${filename}":
        mode    => '0644',
        owner   => root,
        group   => root,
        ensure  => present,
        content => template('sec/single.erb'),
    }

}
