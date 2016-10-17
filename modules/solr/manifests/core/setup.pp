# Class: solr::core::setup
#
# This module manages sets up the solr cores configuration.
# It uses concat::fragment to build up the solr.xml file.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $solr_cores_config    The path to the solr.xml config file.
#
# == Requires:
#
# stdlib, solr::params
#
# == Sample Usage:
#
# include solr::core::setup
#
# class { 'solr::core::setup' : solr_cores_config => '/path/to/solr.xml' }
#
class solr::core::setup(
  $solr_cores_config = $solr::params::solr_cores_config
) inherits solr::params {

  include stdlib
  include solr
  include concat::setup

  # Initilize solr.xml config for fragment building
  concat { $solr_cores_config : }
  concat::fragment { "${solr_cores_config}_head" :
    target  => $solr_cores_config,
    order   => '0',
    content => template('solr/cores/head.xml.erb'),
  }

  concat::fragment { "${solr_cores_config}_tail" :
    target  => $solr_cores_config,
    order   => '99',
    content => template('solr/cores/tail.xml.erb'),
  }

  case $::solr_servlet_engine {
    'tomcat': {
      if defined(Class[tomcat::service]) {
        Concat[$solr_cores_config]  ~> Class[tomcat::service]
      }
    }
    default: {
      if defined(Class[jetty::service]) {
        Concat[$solr_cores_config]  ~> Class[jetty::service]
      }
    }
  }
}
