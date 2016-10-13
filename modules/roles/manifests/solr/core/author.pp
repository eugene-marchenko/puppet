# Class: roles::solr::core::author
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
# include roles::solr::core::author
#
# class { 'roles::solr::core::author' : }
#
#
class roles::solr::core::author() {

  include roles::solrserver

  solr::core { 'author' : }

  cron::crontab { 'solr_optimize_author' :
    command => "curl 'http://localhost:${::jetty_listen_port}/solr/author/update?optimize=true&waitFlush=false' >/dev/null 2>&1",
    minute  => '0',
    hour    => '10,22',
    comment => 'Optimize Solr twice daily',
  }

  Class[roles::solrserver]
  -> Solr::Core['author']
  -> Cron::Crontab['solr_optimize_author']
}
