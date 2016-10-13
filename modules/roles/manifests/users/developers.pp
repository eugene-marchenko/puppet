# Class: roles::users::developers
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
# include roles::users::developers
#
# class { 'roles::users::developers' : }
#
#
class roles::users::developers() {

  include roles::base

  users::manage { 'developers' : override => true }

  $developers = hiera('developers')
  $members = $developers[members]

  sudo::config::sudoer { $developers[members] :
    template => 'sudo/sudo_all_privs.erb',
    require  => Users::Manage[developers],
  }

  Class[roles::base]
  -> Users::Manage[developers]

}
