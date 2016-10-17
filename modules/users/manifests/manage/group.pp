# = Define: users::manage:group
#
# This manages a specific group
#
# == Parameters:
#
# === Required:
#
# === Optional:
#
# $config::     A hash containing the following:
#               $ensure:      Valid values => String 'present or 'absent'
#               $gid:         Valid values => Integer
#
# $ensure::     Overrides the $ensure parameter specified in the $config hash.
#               Defaults to present.
#
# $system::     Whether the group is a system group, valid values are
#               true/false, defaults to false.
#
# $debug::      Whether to enable debug notices/notifies. Defaults to false.
#
# == Actions:
#
# Ensures the group is either present or not.
#
# == Requires:
#
# == Sample Usage:
#
# A typical regular group:
# users::manage::group { 'sysadmins' :
#   config => {
#     'sysadmins' =>
#       {
#       'ensure'    => 'present',
#       'gid'       => '501',
#       },
#   },
# }
#
# A system group:
# users::manage::group { 'jetty' :
#   config => {
#     'jetty' =>
#       {
#       'ensure' => 'present',
#       'uid'    => '48',
#       },
#   },
#   system => true,
# }
#
# A group that is forced to be absent:
# users::manage::group { 'developers' :
#   config => {
#     'developers'  =>
#       {
#         'ensure'    => 'present',
#         'gid'       => '502',
#       },
#   },
#   ensure => 'absent',
# }
#
# A group with no config, lookup done by hiera:
# users::manage::group { 'ops' : }
#
define users::manage::group(
  $config = undef,
  $ensure = 'present',
  $system = false,
  $debug  = false,
) {

  include stdlib
  include users::params

  validate_bool($system,$debug)

  if ! ($config) {
    $tmp_config = hiera($name)
    $config_real = {}
    $config_real[$name] = $tmp_config
  } else {
    $config_real = $config
  }

  $my_hash = $config_real[$name]

  validate_hash($my_hash)

  if $ensure == 'absent' {
    $ensure_real = $ensure
  } else {
    if has_key($my_hash, 'ensure') {
      if $my_hash[ensure] in [ 'present', 'absent' ] {
        $ensure_real = $my_hash[ensure]
      } else {
        fail('ensure value must be present or absent')
      }
    } else {
      $ensure_real = 'present'
    }
  }

  if has_key($my_hash, 'gid') {
    if is_integer($my_hash[gid]) {
      $gid_real = $my_hash[gid]
    } else {
      $gid_real = undef
    }
  } else {
    $gid_real = undef
  }

  if ($system) {
    $system_real = $system
  }

  if ($debug) {
    #To Puppetmaster
    notice("ensure    => ${ensure_real}")
    notice("gid       => ${gid_real}")
    notice("system    => ${system_real}")
  }

  group { $name :
    ensure => $ensure_real,
    gid    => $gid_real,
    system => $system_real,
  }

}
