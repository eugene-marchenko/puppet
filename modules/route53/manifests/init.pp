# Class: route53
#
# This module registers an instance's fqdn with route53 DNS
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $run::        Whether to run the service or not. Defaults to true.
#
# $enable::     Whether to enable the service or not. Defaults to true.
#
# $defaults::   The defaults to set for the file resources. This must be a hash.
#               The default is taken from route53::params class.
#
# $files::      The files to install. This is required to be a hash with the
#               following structure:
#               {
#                 'file1' => { 'key1' => 'val1' ... },
#                 ...
#                 'fileN' => { 'key1' => 'val1' ... },
#               }
#
#               The default is taken from hiera with the lookup keyword
#               'route53_files'. If you redefine this in a hiera datasource
#               then the key to the files hash must be 'route53_files', or
#               alternatively, you can change this by passing in the new key
#               with hiera, e.g.
#               class { 'route53' : files => hiera('other_name') }
#
# == Actions:
#
# Ensures whether the route53 scripts are installed and whether the service
# is enabled and run.
#
# == Requires:
#
# stdlib, route53::params
#
# == Sample Usage:
#
# A parameterized class invocation
# class { 'route53' : }
#
# A standard class invocation
# include route53
#
# Enable the service but do not run it
# class { 'route53' : run => false }
#
# Run the service but do not enable it for initlevels
# class { 'route53' : enable => false }
#
# Override config files
# class { 'route53' : files => hiera('r53_prod_files') }
#
class route53(
  $run          = true,
  $enable       = true,
  $defaults     = $route53::params::defaults,
  $files        = hiera('route53_files'),
) inherits route53::params {

    include stdlib

    $hostname = $route53::params::hostname
    $domain   = $route53::params::domain
    $type     = $route53::params::type
    $address  = $route53::params::address

    class { 'route53::install' :
            defaults => $defaults,
            files    => $files,
    }

    class { 'route53::service' :
            enable  => $enable,
    }

    class { 'route53::service::run' :
            run     => $run,
    }

    motd::register { 'Route53' : }

    anchor { 'route53::begin': }  -> Class[route53::install]
    Class[route53::install]       -> Class[route53::service]
    Class[route53::install]       -> Class[route53::service::run]
    Class[route53::service::run]  -> anchor { 'route53::end': }
}
