# Class: roles::qaproxy
#
# This meta class installs cron resources
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::qaproxy
#
# class { 'roles::qaproxy' : }
#
#
class roles::qaproxy() {

  include roles::base
  include apache
  include newrelic

  apache::vhost::proxy { 'cdn.qa02.thedailybeast.com' :
    port          => '80',
    dest          => 'http://qa02.ec2.thedailybeast.com:6081',
    serveraliases => [ 'cdn.qa02.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'qa02.thedailybeast.com' :
    port          => '80',
    dest          => 'http://qa02.ec2.thedailybeast.com:6081',
    serveraliases => [ 'qa02.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'qa02.thedailybeast.com_6081' :
    servername  => 'qa02.thedailybeast.com',
    port        => '6081',
    dest        => 'http://qa02.ec2.thedailybeast.com:6081',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'qa02.thedailybeast.com_443' :
    servername    => 'qa02.thedailybeast.com',
    serveraliases => [ 'qa02.thedailybeast.com' ],
    port          => '443',
    dest          => 'http://qa02.ec2.thedailybeast.com:6081',
    docroot       => '/var/www',
    ssl_cert      => $apache::params::apache_ssl_cert_tdb,
    ssl_key       => $apache::params::apache_ssl_prv_key_tdb,
    ssl_chain     => $apache::params::apache_ssl_intermediate_cert_tdb,
    ssl           => true,
  }

  apache::vhost::proxy { 'cdn.qa03.thedailybeast.com' :
    port          => '80',
    dest          => 'http://qa03.ec2.thedailybeast.com:80',
    serveraliases => [ 'qa03.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'qa03.thedailybeast.com' :
    port          => '80',
    dest          => 'http://qa03.ec2.thedailybeast.com:6081',
    serveraliases => [ 'qa03.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'qa03.thedailybeast.com_6081' :
    servername  => 'qa03.thedailybeast.com',
    port        => '6081',
    dest        => 'http://qa02.ec2.thedailybeast.com:6081',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'qa03.thedailybeast.com_443' :
    servername    => 'qa03.thedailybeast.com',
    serveraliases => [ 'qa03.thedailybeast.com' ],
    port          => '443',
    dest          => 'http://qa03.ec2.thedailybeast.com:6081',
    docroot       => '/var/www',
    ssl_cert      => $apache::params::apache_ssl_cert_tdb,
    ssl_key       => $apache::params::apache_ssl_prv_key_tdb,
    ssl_chain     => $apache::params::apache_ssl_intermediate_cert_tdb,
    ssl           => true,
  }

  apache::vhost::proxy { 'cdn.qa04.thedailybeast.com' :
    port          => '80',
    dest          => 'http://qa04.ec2.thedailybeast.com:6081',
    serveraliases => [ 'cdn.qa04.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'qa04.thedailybeast.com' :
    port          => '80',
    dest          => 'http://qa04.ec2.thedailybeast.com:6081',
    serveraliases => [ 'qa04.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'qa04.thedailybeast.com_6081' :
    servername  => 'qa04.thedailybeast.com',
    port        => '6081',
    dest        => 'http://qa04.ec2.thedailybeast.com:6081',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'qa04.thedailybeast.com_443' :
    servername    => 'qa04.thedailybeast.com',
    serveraliases => [ 'qa04.thedailybeast.com' ],
    port          => '443',
    dest          => 'http://qa04.ec2.thedailybeast.com:6081',
    docroot       => '/var/www',
    ssl_cert      => $apache::params::apache_ssl_cert_tdb,
    ssl_key       => $apache::params::apache_ssl_prv_key_tdb,
    ssl_chain     => $apache::params::apache_ssl_intermediate_cert_tdb,
    ssl           => true,
  }

  apache::vhost::proxy { 'cdn.qa06.thedailybeast.com' :
    port          => '80',
    dest          => 'http://qa06.ec2.thedailybeast.com:80',
    serveraliases => [ 'qa06.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'qa06.thedailybeast.com' :
    port          => '80',
    dest          => 'http://qa06.ec2.thedailybeast.com:80',
    serveraliases => [ 'qa06.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'qa06.thedailybeast.com_6081' :
    servername  => 'qa06.thedailybeast.com',
    port        => '6081',
    dest        => 'http://qa06.ec2.thedailybeast.com:80',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'qa06.thedailybeast.com_443' :
    servername    => 'qa06.thedailybeast.com',
    serveraliases => [ 'qa06.thedailybeast.com' ],
    port          => '443',
    dest          => 'http://qa06.ec2.thedailybeast.com:6081',
    docroot       => '/var/www',
    ssl_cert      => $apache::params::apache_ssl_cert_tdb,
    ssl_key       => $apache::params::apache_ssl_prv_key_tdb,
    ssl_chain     => $apache::params::apache_ssl_intermediate_cert_tdb,
    ssl           => true,
  }

  apache::vhost::proxy { 'cdn.stage.thedailybeast.com' :
    port          => '80',
    dest          => 'http://cache01-stage.ec2.thedailybeast.com:80',
    serveraliases => [ 'stage.thedailybeast.com' ],
    docroot       => '/var/www',
  }

 apache::vhost::proxy { 'stage.thedailybeast.com' :
    port          => '80',
    dest          => 'http://cache01-stage.ec2.thedailybeast.com:80',
    serveraliases => [ 'stage.thedailybeast.com' ],
    docroot       => '/var/www',
  }

  apache::vhost::proxy { 'stage.thedailybeast.com_6081' :
    servername  => 'stage.thedailybeast.com',
    port        => '6081',
    dest        => 'http://cache01-stage.ec2.thedailybeast.com:80',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'stage.thedailybeast.com_443' :
    servername    => 'stage.thedailybeast.com',
    serveraliases => [ 'stage.thedailybeast.com' ],
    port          => '443',
    dest          => 'http://cache01-stage.ec2.thedailybeast.com:80',
    docroot       => '/var/www',
    ssl_cert      => $apache::params::apache_ssl_cert_tdb,
    ssl_key       => $apache::params::apache_ssl_prv_key_tdb,
    ssl_chain     => $apache::params::apache_ssl_intermediate_cert_tdb,
    ssl           => true,
  }

  apache::vhost::proxy { 'gaia-dev.thedailybeast.com_80' :
    servername  => 'gaia-dev.thedailybeast.com',
    port        => '80',
    dest        => 'http://gaia-dev-1168468742.us-east-1.elb.amazonaws.com:80',
    docroot     => '/var/www',
  }
  
  apache::vhost::proxy { 'gaia-dev-qa02.thedailybeast.com_80' :
    servername  => 'gaia-dev-qa02.thedailybeast.com',
    port        => '80',
    dest        => 'http://gaia-dev-qa02-1509660787.us-east-1.elb.amazonaws.com:80',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'gaia-dev-qa02.thedailybeast.com_4700' :
    servername  => 'gaia-dev-qa02.thedailybeast.com',
    port        => '4700',
    dest        => 'http://gaia-dev-qa02-1509660787.us-east-1.elb.amazonaws.com:4700',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'gaia-dev-qa06.thedailybeast.com_80' :
    servername  => 'gaia-dev-qa06.thedailybeast.com',
    port        => '80',
    dest        => 'http://gaia-dev-qa06-1291733106.us-east-1.elb.amazonaws.com:80',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'gaia-dev-qa06.thedailybeast.com_4700' :
    servername  => 'gaia-dev-qa06.thedailybeast.com',
    port        => '80',
    dest        => 'http://gaia-dev-qa06-1291733106.us-east-1.elb.amazonaws.com:4700',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'gaia-dev.thedailybeast.com_4700' :
    servername  => 'gaia-dev.thedailybeast.com',
    port        => '4700',
    dest        => 'http://gaia-dev-1168468742.us-east-1.elb.amazonaws.com:4700',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'gaia-stage.thedailybeast.com_80' :
    servername  => 'gaia-stage.thedailybeast.com',
    port        => '80',
    dest        => 'http://gaia-stage-569215709.us-east-1.elb.amazonaws.com:80',
    docroot     => '/var/www',
  }

  apache::vhost::proxy { 'gaia-stage.thedailybeast.com_4700' :
    servername  => 'gaia-stage.thedailybeast.com',
    port        => '4700',
    dest        => 'http://gaia-stage-569215709.us-east-1.elb.amazonaws.com:4700',
    docroot     => '/var/www',
  }


  motd::register { 'QAProxy': }

  Class[roles::base]
  -> Class[Apache]
  -> Apache::Vhost::Proxy['cdn.qa02.thedailybeast.com']
  -> Apache::Vhost::Proxy['qa02.thedailybeast.com']
  -> Apache::Vhost::Proxy['qa02.thedailybeast.com_6081']
  -> Apache::Vhost::Proxy['qa02.thedailybeast.com_443']
  -> Apache::Vhost::Proxy['qa03.thedailybeast.com']
  -> Apache::Vhost::Proxy['qa03.thedailybeast.com_6081']
  -> Apache::Vhost::Proxy['qa03.thedailybeast.com_443']
  -> Apache::Vhost::Proxy['qa06.thedailybeast.com']
  -> Apache::Vhost::Proxy['qa06.thedailybeast.com_6081']
  -> Apache::Vhost::Proxy['qa06.thedailybeast.com_443']
  -> Apache::Vhost::Proxy['stage.thedailybeast.com']
  -> Apache::Vhost::Proxy['stage.thedailybeast.com_6081']
  -> Apache::Vhost::Proxy['stage.thedailybeast.com_443']
  -> Apache::Vhost::Proxy['gaia-dev.thedailybeast.com_80']
  -> Apache::Vhost::Proxy['gaia-dev.thedailybeast.com_4700']
  -> Apache::Vhost::Proxy['gaia-dev-qa02.thedailybeast.com_80']
  -> Apache::Vhost::Proxy['gaia-dev-qa02.thedailybeast.com_4700']
  -> Apache::Vhost::Proxy['gaia-dev-qa06.thedailybeast.com_80']
  -> Apache::Vhost::Proxy['gaia-dev-qa06.thedailybeast.com_4700']
  -> Apache::Vhost::Proxy['gaia-stage.thedailybeast.com_80']
  -> Apache::Vhost::Proxy['gaia-stage.thedailybeast.com_4700']
}
