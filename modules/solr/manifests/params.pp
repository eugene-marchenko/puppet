# = Class: solr::params
#
# This module manages default parameters. It does the heavy lifting
# to determine operating system specific parameters.
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class solr::someclass( packages = $solr::params::some_param
# ) inherits solr::params {
# ...do something
# }
#
# class { 'solr::params' : }
#
# include solr::params
#
class solr::params {
  include solr::newrelic

  $supportedversion = '2.7'
  $puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports solr version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Set sane defaults if no facts available for override
    $solr_package = $::solr_servlet_engine ? {
      'tomcat' => 'solr-tomcat',
      default  => 'solr-jetty',
    }

    $solr_home = $::solr_home ? {
      /''|undef/  => '/usr/share/solr',
      default     => $::solr_home,
    }

    $solr_conf_dir = $::solr_conf_dir ? {
      /''|undef/  => '/etc/solr/conf',
      default     => $::solr_conf_dir,
    }

    $solr_data_dir_symlinks = $::solr_data_dir_symlinks ? {
      /''|undef/  => [ '/var/lib/solr/data', "${solr_home}/data" ],
      default     => split($::solr_data_dir_symlinks, '\s*,\s*')
    }

    $solr_cores_config = $::solr_cores_config ? {
      /''|undef/  => "${solr_home}/solr.xml",
      default     => $::solr_cores_config,
    }

    case $::lsbdistcodename {
      'precise': {
        $solr_user = $::solr_servlet_engine ? {
          'tomcat'  => 'tomcat6',
          default   => 'jetty',
        }
        $solr_group = $::solr_servlet_engine ? {
          'tomcat'  => 'tomcat6',
          default   => 'jetty',
        }
      }
    }

    # Resource Defaults
    $solr_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'solr-package',
    }

    $solr_packages = {
      "${solr_package}" => {},
    }

#    if $env =~ /qa|stage|prod/ {
#      $solr_schema_config = {
#          'ensure'  => 'present',
#          'owner'   => 'root',
#          'group'   => 'root',
#          'mode'    => '0644',
#          'source' => 'puppet:///modules/solr/configs/schema_qa02.xml'
#      }
#    } else {
      $solr_schema_config = {
          'ensure'  => 'present',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'source' => 'puppet:///modules/solr/configs/schema.xml'
      }
#    }

    $solr_configs = {
      '/usr/share/jetty/webapps/solr/conf/elevate.xml'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source' => 'puppet:///modules/solr/configs/elevate.xml'
      },
      '/usr/share/jetty/webapps/solr/conf/protwords.txt'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source' => 'puppet:///modules/solr/configs/protwords.txt'
      },
      '/usr/share/jetty/webapps/solr/conf/schema.xml'       => $solr_schema_config,
      '/usr/share/jetty/webapps/solr/conf/scripts.conf'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source' => 'puppet:///modules/solr/configs/scripts.conf'
      },
      '/usr/share/jetty/webapps/solr/conf/solrconfig.xml'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source' => 'puppet:///modules/solr/configs/solrconfig.xml'
      },
      '/usr/share/jetty/webapps/solr/conf/spellings.txt'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source' => 'puppet:///modules/solr/configs/spellings.txt'
      },
      '/usr/share/jetty/webapps/solr/conf/stopwords.txt'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source' => 'puppet:///modules/solr/configs/stopwords.txt'
      },
      '/usr/share/jetty/webapps/solr/conf/synonyms.txt'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source' => 'puppet:///modules/solr/configs/synonyms.txt'
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
