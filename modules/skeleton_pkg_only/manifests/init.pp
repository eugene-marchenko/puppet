# Class: skeleton_pkg_only
#
# This class manages skeleton_pkg_only packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether skeleton_pkg_only is installed or not.
#                   Valid values are true and false. Defaults to true.
#
# $version::        The version of the package to install, e.g '1.2.3'.
#
# == Requires:
#
# skeleton_pkg_only::params
#
# == Sample Usage:
#
# include skeleton_pkg_only
#
# class { 'skeleton_pkg_only' : running => false }
#
# class { 'skeleton_pkg_only' : installed => false }
#
class skeleton_pkg_only(
  $installed            = true,
  $version              = 'latest',
) inherits skeleton_pkg_only::params {

  case $installed {
    false: {
      class { 'skeleton_pkg_only::packages' :
        installed => false,
        version   => $version,
      }
    }
    default: {
      class { 'skeleton_pkg_only::packages' :
        installed => true,
        version   => $version,
      }
    }
  }
}
