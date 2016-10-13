class logstash::conf  {

    file { "/etc/logstash/conf.d":
        ensure => directory
    }

    file { "/etc/logstash/patterns":
        ensure => directory
    }

    file { "/etc/default/logstash":
        mode       => 644, owner => root, group => root,
        ensure     => present,
        path       => "/etc/default/logstash",
    }

    file { "shipper-input":
        mode       => 755, owner => root, group => root,
        ensure     => present,
        path       => "/etc/logstash/conf.d/shipper-input.conf",
        content    => template("logstash/shipper-input.conf.erb"),
    }

    file { "shipper-output":
        mode       => 755, owner => root, group => root,
        ensure     => present,
        path       => "/etc/logstash/conf.d/shipper-output.conf",
        content    => template("logstash/shipper-output-redis.conf.erb"),
    }

    file { "shipper-filter":
        mode       => 755, owner => root, group => root,
        ensure     => present,
        path       => "/etc/logstash/conf.d/shipper-filter.conf",
        content    => template("logstash/shipper-filter.conf.erb"),
    }

    file { "grok-patterns":
        mode       => 644, owner => root, group => root,
        ensure     => present,
        path       => "/etc/logstash/patterns/grok-patterns",
        source     => "puppet:///modules/logstash/patterns/grok-patterns",
    }

    file { "linux-syslog":
        mode       => 644, owner => root, group => root,
        ensure     => present,
        path       => "/etc/logstash/patterns/linux-syslog",
        source     => "puppet:///modules/logstash/patterns/linux-syslog",
    }

}
