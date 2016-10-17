# = Define: users
#
# This installs default user/group/key resources
#
# == Parameters:
#
# === Optional:
#
# $users::      The users types to install. This must be an array. Defaults to
#               [ 'sysadmins' ].
#
# $groups_key:: The key to use to access the groups config. Defaults to
#               'groups'.
#
# $ensure::     Valid values are present or absent. Defaults to present.
#
# $override::   Whether to grab user/group/key resource information from
#               the users::params class or whether to grab it from an external
#               data source. The default is to grab it from the users::params
#               class so that this module is functional without the need for
#               external data source information. Valid values are true and
#               false. Defaults to false.
#
# == Actions:
#
# Ensures whether the resources are present or not.
#
# == Requires:
#
# stdlib
# users::params
#
# == Sample Usage:
#
# A parameterized class invocation
# class { users : }
#
# A standard class invocation
# include users
#
# Ensure that the users/groups/keys are uninstalled
# class { 'users' : ensure => 'absent' }
#
# Use external data
# class { 'users' : override => true }
#
# Install multiple user types
# class { 'users' : users => [ 'sysadmins', 'developers' ] }
#
class users(
  $users = [ 'sysadmins' ],
  $ensure = 'present',
  $override = false,
  $group_key = 'groups',
) inherits users::params {

  include stdlib

  validate_bool($override)
  validate_array($users)

  class { 'users::groups' :
    ensure   => $ensure,
    override => $override,
    key      => $group_key,
  }

  users::manage { $users :
    ensure   => $ensure,
    override => $override,
  }

  motd::register { 'Users' : }

}
