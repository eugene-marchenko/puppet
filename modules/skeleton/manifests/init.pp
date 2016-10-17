# Class: skeleton
#
# This class manages skeleton packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether skeleton is installed or not. Valid
#                   values are true and false. Defaults to true.
#
# $running::        Whether the service is running or stopped.
#
# $enabled::        Whether the service is enabled or disabled on boot.
#
# $version::        The version of the package to install, e.g '1.2.3'.
#
# == Requires:
#
# skeleton::params
#
# == Sample Usage:
#
# include skeleton
#
# class { 'skeleton' : running => false }
#
# class { 'skeleton' : installed => false }
#
class skeleton(
  $installed            = true,
  $running              = true,
  $enabled              = true,
  $version              = 'latest',
) inherits skeleton::params {

  case $installed {
    false: {
      class { 'skeleton::packages' :
        installed => false,
        version   => $version,
      }
      class { 'skeleton::configs' :
        installed => false,
      }
      # Setup resource dependency chain
      Class[skeleton::configs]
        -> Class[skeleton::packages]
    }
    default: {
      class { 'skeleton::packages' :
        installed => true,
        version   => $version,
      }
      class { 'skeleton::configs' :
        installed => true,
      }
      class { 'skeleton::services' :
        running => $running,
        enabled => $enabled,
      }
      # Setup resource dependency chain
      Class[skeleton::packages]
        -> Class[skeleton::configs]
        ~> Class[skeleton::services]
    }
  }
}
