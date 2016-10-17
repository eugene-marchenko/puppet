# Class: ntp
#
# This class manages ntp packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether ntp is installed or not. Valid
#                   values are true and false. Defaults to true.
#
# == Requires:
#
# stdlib, ntp::params
#
# == Sample Usage:
#
# include ntp
#
# class { 'ntp' : }
#
# class { 'ntp' : installed => false }
#
class ntp(
  $installed = true,
) inherits ntp::params {

  include stdlib

  case $installed {
    true: {
      include ntp::packages
      include ntp::configs
      include ntp::services

      Class[ntp::packages]
        -> Class[ntp::configs]
        ~> Class[ntp::services]
    }
    false: {
      class { 'ntp::packages': installed => false }
      class { 'ntp::configs':  installed => false }
      class { 'ntp::services': running   => false, enabled => false }

      Class[ntp::services]
        -> Class[ntp::configs]
        -> Class[ntp::packages]
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
