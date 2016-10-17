# Class: solr::core
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
# $solr_xml_conf    The path to the solr.xml config file.
#
# == Requires:
#
# stdlib, solr::params
#
# == Sample Usage:
#
# include solr::core
#
# class { 'solr::core' : solr_xml_conf => '/path/to/solr.xml' }
#
define solr::core(
  $instance_dir       = '',
  $data_dir           = '',
  $solr_config        = '',
  $solr_schema        = '',
  $priority           = '10',
  $solr_conf_dir      = $solr::params::solr_conf_dir,
  $solr_cores_config  = $solr::params::solr_cores_config,
  $solr_home          = $solr::params::solr_home,
  $solr_user          = $solr::params::solr_user,
) {

  include stdlib
  include solr::params
  include solr::core::setup
  include concat::setup


  $user = $solr::params::solr_user
  $symlinks = $solr::params::solr_data_dir_symlinks

  $solr_data_dir = $::solr_data_dir ? {
    /''|undef/  => "/opt/cq5/${name}/solr/data",
    default     => $::solr_data_dir,
  }

  exec { "solr(mkdir -p ${solr_data_dir})" :
    command => "install -o ${user} -d ${solr_data_dir}",
    unless  => "test -d ${solr_data_dir}",
  }

  file { "/var/lib/solr/${name}" :
    ensure  => 'link',
    target  => $solr_data_dir,
    force   => true,
    tag     => 'solr-symlink-dirs',
    require => Exec["solr(mkdir -p ${solr_data_dir})"],
  }
  
  file { "/opt/cq5/${name}/solr/": 
    ensure  => directory,
    owner   => "${user}",
    group   => "${user}",
    mode    => 0644,
    recurse => true,
  }

  if $instance_dir == '' {
    $instance_dir_real = "${solr_home}/${name}"
  } else {
    $instance_dir_real = $instance_dir
  }

  if $data_dir == '' {
    $data_dir_real = "${solr_data_dir}/${name}"
  } else {
    $data_dir_real = $data_dir
  }

# TODO: Implement alternate config files
#   if $solr_config == '' {
#     $solr_config_real = undef
#   } else {
#     $solr_config_real = $solr_config
#   }
#
#  if $solr_schema == '' {
#    $solr_schema_real = undef
#  } else {
#    $solr_schema_real = $solr_schema
#  }

  exec { "solr::core::${name}(mkdir -p ${instance_dir_real})" :
    command => "mkdir -p ${instance_dir_real}",
    unless  => "test -d ${instance_dir_real}",
  }

  exec { "solr::core::${name}(mkdir -p ${data_dir_real})" :
    command => "install -o ${solr_user} -d ${data_dir_real}",
    unless  => "test -d ${data_dir_real}",
  }

  file { "${instance_dir_real}/conf" :
    ensure => 'link',
    target => $solr_conf_dir,
    force  => true,
  }

  concat::fragment { "${solr_cores_config}_${name}" :
    target  => $solr_cores_config,
    order   => $priority,
    content => template('solr/cores/core.xml.erb'),
  }

  motd::register { "Solr::Core::${name}" : }

  Exec["solr::core::${name}(mkdir -p ${instance_dir_real})"]
    -> Exec["solr::core::${name}(mkdir -p ${data_dir_real})"]
    -> File["${instance_dir_real}/conf"]
    -> Concat::Fragment["${solr_cores_config}_${name}"]
}
