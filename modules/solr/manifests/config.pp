# Define: solr::config
#
# This module installs solr configs
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $configs::    The configs to install. This must be an hash of configs
#
# == Requires:
#
# stdlib, solr::params
#
# == Sample Usage:
#
# solr::config { 'solr-configs':
#   configs => hiera('solr_configs')
# }
#
define solr::config(
  $configs,
) {

  include stdlib
  include solr::params

  validate_hash($configs)

  $defaults = { 'tag' => 'solr-config' }

  create_resources(file, $configs, $defaults)

  include solr::newrelic
}
