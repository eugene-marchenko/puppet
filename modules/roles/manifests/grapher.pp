# Class: roles::grapher
#
# This class installs logstash, redis, elasticsearch and more.
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
# include roles::grapher
#
# class { 'roles::grapher' : }
#
#
class roles::grapher() {

  include roles::base

  include java
  include ruby
  include redis
  include logstash
  include elasticsearch
  include kibana

  package { 'ruby-bundler': }

  apt::source { 'chris-lea' :
      location  => 'http://ppa.launchpad.net/chris-lea/redis-server/ubuntu',
      release   => 'precise',
      repos     => 'main',
      key       => 'C7917B12',
  }

  apt::source { 'wolfnet' :
      location  => 'http://ppa.launchpad.net/wolfnet/logstash/ubuntu',
      release   => 'precise',
      repos     => 'main',
      key       => '28B04E4A',
  }

  apt::source { 'eslam-husseiny' :
      location  => 'http://ppa.launchpad.net/eslam-husseiny/elasticsearch/ubuntu',
      release   => 'precise',
      repos     => 'main',
      key       => 'EFA56D49',
  }

  file { 'logstash':
      mode      => 644, owner => root, group => root,
      ensure    => present,
      path      => '/etc/default/logstash',
      source    => 'puppet:///modules/logstash/default',
  }

  logstash::input::file { 'syslog':
      type      => 'syslog',
      path      => [ '/var/log/syslog', '/var/log/*.log' ],
  }

  logstash::output::redis { 'redis':
      host      => [ '127.0.0.1' ],
      data_type => 'list',
      key       => 'logstash',
      batch     => true,
  }

  logstash::input::redis { 'redis':
      type           => 'redis',
      host           => '127.0.0.1',
      data_type      => 'list',
      key            => 'logstash',
      message_format => 'json_event',
  }

  logstash::output::elasticsearch { 'elasticsearch':
      type => 'syslog',
  }

  Class[ruby] -> Package['ruby-bundler']
  Package['ruby-bundler'] -> Class[kibana]

}
