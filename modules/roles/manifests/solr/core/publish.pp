# Class: roles::solr::core::publish
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
# include roles::solr::core::publish
#
# class { 'roles::solr::core::publish' : }
#
#
class roles::solr::core::publish() {

  include roles::solrserver

  solr::core { 'publish' : }

  cron::crontab { 'solr_optimize_publish' :
    command => "curl 'http://localhost:${::jetty_listen_port}/solr/publish/update?optimize=true&waitFlush=false' >/dev/null 2>&1",
    minute  => '0',
    hour    => '10,22',
    comment => 'Optimize Solr twice daily',
  }

  Class[roles::solrserver]
  -> Solr::Core['publish']
  -> Cron::Crontab['solr_optimize_publish']

}
