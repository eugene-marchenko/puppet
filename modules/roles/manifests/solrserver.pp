# Class: roles::solrserver
#
# This class installs solr resources
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
# include roles::solrserver
#
# class { 'roles::solrserver' : }
#
#
class roles::solrserver() {

  include roles::base
  include roles::params

  # Validate some necessary facts
  if ! ($::jetty_listen_port == '8983') {
    fail('jetty_listen_port fact must be set to \'8983\'')
  }

  if ! ($::jetty_listen_address == '0.0.0.0') {
    fail('jetty_listen_address fact must be set to \'0.0.0.0\'')
  }

  # if ! ($::jetty_java_options =~ /-Dcom\.sun\.management\.jmxremote/) {
  #   fail('jetty_java_options fact needs to enable JMX')
  # }

  if ! ($::github_user) {
    fail('github_user fact not set, this is needed for solr configs')
  }

  if ! ($::github_pass) {
    fail('github_pass fact not set, this is needed for solr configs')
  }

  $github_solr_schema_url = $::github_solr_schema_url ? {
    undef   => 'https://raw.githubusercontent.com/dailybeast/nwdb/master/search/src/main/resources/solr/conf/schema.xml',
    ''      => 'https://raw.githubusercontent.com/dailybeast/nwdb/master/search/src/main/resources/solr/conf/schema.xml',
    default => $::github_solr_schema_url,
  }

  $github_solr_config_url = $::github_solr_config_url? {
    undef   => 'https://raw.githubusercontent.com/dailybeast/nwdb/master/search/src/main/resources/solr/conf/solrconfig.xml',
    ''      => 'https://raw.githubusercontent.com/dailybeast/nwdb/master/search/src/main/resources/solr/conf/solrconfig.xml',
    default => $::github_solr_config_url,
  }

  apt::source { 'solr-3.3' :
    location  => 'http://ppa.launchpad.net/webops/solr-3.3/ubuntu',
    release   => 'precise',
    repos     => 'main',
    key       => '7E731D72',
  }

  include java
  include jetty

  file { '/mnt/log/jetty' :
    ensure  => 'directory',
    owner   => 'jetty',
    group   => 'adm',
    mode    => '0750',
    notify  => Class[jetty::service],
  }

  file { '/var/log/jetty' :
    ensure  => 'link',
    target  => '/mnt/log/jetty',
    force   => true,
    notify  => Class[jetty::service],
  }

  jetty::webapp { 'zapcat' :
    config  => 'jetty/Ubuntu/precise/jetty-jmx.xml',
    warfile => 'http://bootstrap.ec2.thedailybeast.com/public/zapcat/zapcat-1.2.war'
  }

  include solr

  cron::crontab { 'solr_optimize' :
    command => "curl 'http://localhost:${::jetty_listen_port}/solr/update?optimize=true&waitFlush=false' >/dev/null 2>&1",
    minute  => '0',
    hour    => '10,22',
    comment => 'Optimize Solr twice daily',
  }

  Class[roles::base]
  -> Class[java]
  -> Class[jetty]
  -> File['/mnt/log/jetty']
  -> File['/var/log/jetty']
  -> Jetty::Webapp[zapcat]
  -> Class[solr]
  -> Cron::Crontab['solr_optimize']

}
