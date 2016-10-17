class sec::conf  {

    exec { 'sec_conf_dir':
        command => 'mkdir /etc/sec',
        creates => '/etc/sec',
    }

    sec_config { $sec_filename:
        filename => $sec_filename,
        desc     => $sec_desc,
        pattern  => $sec_pattern,
        notify   => Service['sec'],
    }

}
