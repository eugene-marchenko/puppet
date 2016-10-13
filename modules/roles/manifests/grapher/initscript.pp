class logstash::initscript  {

    service { "logstash":
        name       => "logstash",
        ensure     => running,
        enable     => true,
        pattern    => "logstash.jar",
        hasrestart => true,
        require    => Package["logstash"],
    }
}
