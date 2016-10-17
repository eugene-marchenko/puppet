# Class: activemq
#
# This class manages activemq packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether activemq is installed or not. Valid
#                   values are true and false. Defaults to true.
#
# == Requires:
#
# stdlib, activemq::params
#
# == Sample Usage:
#
# include activemq
#
# class { 'activemq' : }
#
# class { 'activemq' : installed => false }
#
class activemq(
  $installed = true,
) inherits activemq::params {

  include stdlib

  case $installed {
    true: {
      include activemq::packages
      include activemq::configs
      include activemq::services

      Class[activemq::packages]
        -> Class[activemq::configs]
        ~> Class[activemq::services]
    }
    false: {
      class { 'activemq::packages': installed => false }
      class { 'activemq::configs':  installed => false }
      class { 'activemq::services': running   => false, enabled => false }

      Class[activemq::services]
        -> Class[activemq::configs]
        -> Class[activemq::packages]
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
