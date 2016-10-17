# Class: java
#
# This class manages java packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether java is installed or not. Valid
#                   values are true and false. Defaults to true.
#
# $version::        The version of the package to install, e.g '1.2.3'.
#
# == Requires:
#
# java::params
#
# == Sample Usage:
#
# include java
#
# class { 'java' : running => false }
#
# class { 'java' : installed => false }
#
class java(
  $installed            = true,
  $version              = 'latest',
) inherits java::params {

  case $installed {
    false: {
      class { 'java::packages' :
        installed => false,
        version   => $version,
      }
    }
    default: {
      class { 'java::packages' :
        installed => true,
        version   => $version,
      }
    }
  }
}
