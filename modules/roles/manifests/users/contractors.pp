# Class: roles::users::contractors
#
# This class installs developer users.
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
# include roles::users::contractors
#
# class { 'roles::users::contractors' : }
#
#
class roles::users::contractors() {

  include roles::base

  users::manage { 'contractors' : override => true }

  $contractors = hiera('contractors')
  $members = $contractors[members]

  sudo::config::sudoer { $contractors[members] :
    template => 'sudo/sudo_no_privs.erb',
    require  => Users::Manage[contractors],
  }

  Class[roles::base]
  -> Users::Manage[contractors]

}
