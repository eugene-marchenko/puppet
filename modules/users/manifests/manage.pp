# = Define: users::manage
#
# This finds the config for and installs user/group/key resources
#
# == Parameters:
#
# === Optional:
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
# $manage_ssh:: Whether to manage the user's ssh key. Boolean. Defaults to true.
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
# Install sysadmin users from users::params defaults
# users::manage { 'sysadmins' : }
#
# Ensure that developers are uninstalled
# users::manage { 'developers' : ensure => 'absent' }
#
# Use external data
# users::manage { 'sysadmins' : override => true }
#
define users::manage(
  $ensure     = 'present',
  $override   = false,
  $manage_ssh = true,
) {

  include stdlib
  include users::params

  validate_bool($override,$manage_ssh)

  if $override {
    $item = hiera($name)
    $config_real = undef
  } else {
    if has_key($users::params::groups_config, $name) {
      $item = $users::params::groups_config[$name]
      $config_real = $users::params::users_config
    } else {
      fail("Group '${name}' not found")
    }
  }

  if has_key($item, 'members') {
    $members = $item[members]
  } else {
    fail("Group ${name} has no key 'members'")
  }

  @users::manage::user { $members:
    ensure => $ensure,
    config => $config_real,
    tag    => $name,
  }

  Users::Manage::User <| tag == $name |>

  if $manage_ssh {
    @users::manage::sshkey { $members:
      ensure => $ensure,
      config => $config_real,
      tag    => $name,
    }

    Users::Manage::Sshkey <| tag == $name |>
  }
}
