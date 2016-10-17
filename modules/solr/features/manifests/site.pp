# define solr::package
node 'solr-package-default' {
  include solr::params
  solr::package { 'solr-packages' :
    packages => $solr::params::solr_packages,
    defaults => $solr::params::solr_package_defaults,
  }
}

node 'solr-package-no-params' {
  solr::package { 'solr-packages' : }
}

# define solr::config
node 'solr-config-default' {
  include solr::params
  solr::config { 'solr-configs' :
    configs => $solr::params::solr_configs,
  }
}

node 'solr-config-no-params' {
  solr::config { 'solr-configs' : }
}

# class solr
node 'class-solr-default' {
  include solr
}

node 'class-solr-uninstalled' {
  class { 'solr' : installed => false }
}

# define solr::core
node 'solr-core-1-core' {
  include solr
  solr::core { 'core0' : }
}

node 'solr-core-multiple-cores' {
  include solr
  solr::core { 'core0' : }
  solr::core { 'core1' : }
}

node 'solr-core-with-parameters' {
  include solr
  solr::core { 'core0' :
    instance_dir => '/data/solr/core0',
    data_dir     => '/data/solr/core0/data',
  }
}
