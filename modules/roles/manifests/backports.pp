# Class: roles::backports
#
# This class installs the backports apt source. For inclusion in other
# roles.
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
# include roles::backports
#
# class { 'roles::backports' : }
#
#
class roles::backports() {

  apt::source { 'nw-backports' :
    location  => 'http://ppa.launchpad.net/webops/backports/ubuntu',
    release   => 'precise',
    repos     => 'main',
    key       => '7E731D72',
  }

}
