# Class: roles::stompserver
#
# This meta class installs stomp server resources
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::stompserver
#
# class { 'roles::stompserver' : }
#
#
class roles::stompserver() {

  include roles::base
  include activemq

  Class[roles::base]
  -> Class[activemq]
}
