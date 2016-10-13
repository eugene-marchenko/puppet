class logstash::base  {

    file { "/etc/logstash":
        ensure     => directory,
    }

    file { "logstash-init":
        mode       => 755, owner => root, group => root,
        ensure     => present,
        path       => "/etc/init.d/logstash",
    }

    file { "logstash.jar":
        mode       => 755, owner => root, group => root,
        ensure     => present,
        path       => "/usr/share/logstash/logstash.jar",
    }

}
