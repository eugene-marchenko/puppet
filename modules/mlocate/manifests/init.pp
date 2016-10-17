# Class: mlocate
#
# This class manages mlocate packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether mlocate is installed or not. Valid
#                   values are true and false. Defaults to true.
#
# $enabled::        Whether the service is enabled or disabled.
#
# $version::        The version of the package to install, e.g '1.2.3'.
#
# == Requires:
#
# mlocate::params
#
# == Sample Usage:
#
# include mlocate
#
# class { 'mlocate' : enabled => false }
#
# class { 'mlocate' : installed => false }
#
class mlocate(
  $installed            = true,
  $enabled              = true,
  $version              = 'latest',
) inherits mlocate::params {

  case $installed {
    false: {
      class { 'mlocate::packages' :
        installed => false,
        version   => $version,
      }
      class { 'mlocate::configs' :
        installed => false,
      }
      # Setup resource dependency chain
      Class[mlocate::configs]
        -> Class[mlocate::packages]
    }
    default: {
      class { 'mlocate::packages' :
        installed => true,
        version   => $version,
      }
      class { 'mlocate::configs' :
        installed => true,
      }
      class { 'mlocate::services' :
        enabled => $enabled,
      }
      # Setup resource dependency chain
      Class[mlocate::packages]
        -> Class[mlocate::configs]
        ~> Class[mlocate::services]
    }
  }
}
