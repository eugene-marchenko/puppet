# Define: solr::package
#
# This module installs solr packages
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $packages::   The packages to install. This must be an hash of packages
#
# $defualts::   The package defaults to use. Must be a hash.
#
# == Requires:
#
# stdlib, solr::params
#
# == Sample Usage:
#
# solr::package { 'solr-packages':
#   packages => hiera('solr_packages')
#   defualts => hiera('solr_package_defaults')
# }
#
define solr::package(
  $packages,
  $defaults,
) {
  include solr::newrelic
  include java::packages
  include roles::packages
  include stdlib

  create_resources(package, $packages, $defaults)
}
