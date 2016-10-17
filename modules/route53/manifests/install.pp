# = Class: route53::install
#
# This module manages the route53 configuration file.
#
# == Parameters:
#
# === Optional:
#
# $defaults::     This is a hash containing defaults for create_resources.
#
# $files::        This is a hash containing files and their resource parameters.
#
# == Actions:
#
# Ensures the creation of default file resources.
#
# == Requires:
#
# stdlib, route53::params
#
# == Sample Usage:
#
# class { route53::install : }
#
# Override the hiera default
#
# class { route53::install : config => hiera('some_other_files') }
#
class route53::install(
  $defaults  = $route53::params::defaults,
  $files     = hiera('route53_files'),
) inherits route53::params {

  include stdlib

  create_resources(file, $files, $defaults)

}
