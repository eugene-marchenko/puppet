# General settings for standard types
Exec { path => '/bin:/sbin:/usr/bin:/usr/sbin' }
filebucket { 'server': server => 'puppet.ec2.newsweek.com' }

# Very important setting, this ensures that we can have multiple
# apt source installs that notify apt-update but package installs wait to
# install until apt-update runs
Package { require => Class[apt::update] }

node default {
  include apt
  include roles::base

  $roles = split($::roles, '\s*,\s*')

  # Role Parsing
  if 'dispatcher' in $roles {
    include roles::dispatcher
  }

  if 'ftpserver' in $roles {
    include roles::ftpserver
  }

  if 'logserver' in $roles {
    include roles::logserver
  }

  if 'logserver_varnish' in $roles {
    include roles::logserver::varnish
  }

  if 'remote_syslog' in $roles {
    include roles::remotelog
  }

  if 'mailrelay' in $roles {
    include roles::mailrelay
  }

  if 'misc' in $roles {
    include roles::misc::vhosts
  }

  if 'solr' in $roles {
    include roles::solrserver
  }

  if 'solr_core_author' in $roles {
    include roles::solr::core::author
  }

  if 'solr_core_publish' in $roles {
    include roles::solr::core::publish
  }

  if 'varnishserver' in $roles {
    include roles::varnishserver
  }

  if 'varnish_remotelog' in $roles {
    include roles::varnishserver::remotelog
  }

  if 'author' in $roles {
    include roles::cq5::author
  }

  if 'secure_author' in $roles {
    include roles::cq5::author::secure
  }

  if 'secure_author_cache' in $roles {
    include roles::cq5::author::secure_cache
  }

  if 'publisher' in $roles {
    include roles::cq5::publish
  }

  if 'jmeternode' in $roles {
    include roles::jmeternode
  }

  if 'cron_snapshot_rotator' in $roles {
    include roles::cron::snapshot::rotator
  }

  if 'cron_mysql_backups' in $roles {
    include roles::cron::mysql::backups
  }

  if 'cron_analytics' in $roles {
    include roles::cron::analytics
  }

  if 'cronserver' in $roles {
    include roles::cronserver
  }

  if 'grapher' in $roles {
    include roles::grapher
  }

  if 'pvault' in $roles {
    include roles::pvault
  }

  if 'debbuilder' in $roles {
    include roles::debbuilder
  }

  if 'rootdomain' in $roles {
    include roles::rootdomain
  }

  if 'developers' in $roles {
    include roles::users::developers
  }

  if 'contractors' in $roles {
    include roles::users::contractors
  }

  if 'stompserver' in $roles {
    include roles::stompserver
  }

  if 'buildserver' in $roles {
    include roles::buildserver
  }

  if 'jenkins' in $roles {
    include roles::jenkins
  }

  if 'qaproxy' in $roles {
    include roles::qaproxy
  }

  if 'appproxy' in $roles {
    include roles::appproxy
  }

}
