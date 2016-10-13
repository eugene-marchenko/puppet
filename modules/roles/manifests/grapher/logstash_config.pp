define logstash::logstash_config ( $pattern, $desc )

{
    #Just for readability
    $filename = $title

    file { "/etc/logstash/conf.d/${filename}":
        mode       => 644, owner => root, group => root,
        ensure     => present,
        content    => template("logstash/shipper-input.conf.erb"),
    }

    file { "/etc/logstash/conf.d/${filename}":
        mode       => 644, owner => root, group => root,
        ensure     => present,
        content    => template("logstash/shipper-output.conf.erb"),
    }

    file { "/etc/logstash/conf.d/${filename}":
        mode       => 644, owner => root, group => root,
        ensure     => present,
        content    => template("logstash/shipper-filter.conf.erb"),
    }

}
