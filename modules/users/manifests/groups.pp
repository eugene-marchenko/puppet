# = Class: users::groups
#
# This finds the group resources and installs them
#
# == Parameters:
#
# === Optional:
#
# $key::        The name of the group resource key. Defaults to groups.
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
# Ensures whether the group resources are present or not.
#
# == Requires:
#
# stdlib
# users::params
#
# == Sample Usage:
#
# Parameterized class invocation
# class { 'users::groups' : }
#
# Standard include invocation
# include users::groups
#
# Ensure that groups are absent
# class { 'users::groups' : ensure => absent }
#
# Lookup in Hiera
# class { 'users::groups' : override => true }
#
# Lookup in Hiera, but with different key
#
# class { 'users::groups' : key => 'unix_groups', override => true }
#
class users::groups(
  $key = 'groups',
  $ensure = 'present',
  $override = false,
) inherits users::params {

  include stdlib

  validate_bool($override)

  if $override {
    $item = hiera($key)
    $config_real = undef
  } else {
    $item = $users::params::groups
    $config_real = $users::params::groups_config
  }

  if empty($item) {
    fail("Could not find item with name ${key}")
  } else {
    if ! has_key($item, 'members') {
      fail("Item ${item} has no key 'members'")
    } else {
      $members = $item[members]
    }
  }

  @users::manage::group { $members:
    ensure => $ensure,
    config => $config_real,
    tag    => $key,
  }

  Users::Manage::Group <| tag == $key |>
}
