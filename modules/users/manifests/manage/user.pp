# = Define: users::manage:user
#
# This manages a specific user
#
# == Parameters:
#
# === Required:
#
# === Optional:
#
# $config::     A hash containing the following:
#               $ensure:      Valid values => String 'present or 'absent'
#               $uid:         Valid values => Integer
#               $gid:         Valid values => Integer or Group name
#               $groups:      Valid values => Array of group name(s)
#               $comment:     Valid values => String
#               $shell:       Valid values => String
#               $home:        Valid values => String
#               $password:    Valid values => String
#
# $ensure::     Overrides the $ensure parameter specified in the $config hash.
#               Defaults to present.
#
# $system::     Whether the user is a system user, valid values are true/false,
#               defaults to false.
#
# $debug::      Whether to enable debug notices/notifies. Defaults to false.
#
# == Actions:
#
# Ensures the user is either present or not.
#
# == Requires:
#
# == Sample Usage:
#
# A typical regular user:
# users::manage::user { 'johndoe' :
#   config => {
#     'johndoe' =>
#       {
#       'ensure'    => 'present',
#       'uid'       => '2000',
#       'gid'       => 'users',
#       'groups'    => [ 'operator' ],
#       'comment'   => 'John Doe (User)',
#       'shell'     => '/bin/bash',
#       'home'      => '/home/johndoe',
#       'password'  => '$1ef3afdsSa$323442A56dadhJk/',
#       },
#   },
# }
#
# A system user:
# users::manage::user { 'jetty' :
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
# A user that is forced to be absent:
# users::manage::user { 'johndoe' :
#   config => {
#     'johndoe' =>
#       {
#       'ensure'    => 'present',
#       'uid'       => '2000',
#       'gid'       => '100',
#       'groups'    => [ 'operator' ],
#       'comment'   => 'John Doe (User)',
#       'shell'     => '/bin/bash',
#       'home'      => '/home/johndoe',
#       'password'  => '$1ef3afdsSa$323442A56dadhJk/',
#       },
#   },
#   ensure => 'absent',
# }
#
# A user with no config, lookup done by hiera
# users::manage::user { 'developers' : }
#
define users::manage::user(
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

  if has_key($my_hash, 'uid') {
    if is_integer($my_hash[uid]) {
      $uid_real = $my_hash[uid]
    } else {
      $uid_real = undef
    }
  } else {
    $uid_real = undef
  }

  if has_key($my_hash, 'gid') {
    if is_integer($my_hash[gid]) or is_string($my_hash[gid]) {
      $gid_real = $my_hash[gid]
    } else {
      $gid_real = undef
    }
  } else {
    $gid_real = undef
  }

  if has_key($my_hash, 'groups') {
    if is_array($my_hash[groups]) {
      $groups_real = $my_hash[groups]
    } else {
      $groups_real = undef
    }
  } else {
    $groups_real = undef
  }

  if has_key($my_hash, 'comment') {
    if is_string($my_hash[comment]) {
      $comment_real = $my_hash[comment]
    } else {
      $comment_real = undef
    }
  } else {
    $comment_real = undef
  }

  if has_key($my_hash, 'shell') {
    if is_string($my_hash[shell]) {
      $shell_real = $my_hash[shell]
    } else {
      $shell_real = $users::params::shell
    }
  } else {
    $shell_real = $users::params::shell
  }

  if has_key($my_hash, 'home') {
    if is_string($my_hash[home]) {
      $home_real = $my_hash[home]
    } else {
      $home_real = "/home/${name}"
    }
  } else {
    $home_real = "/home/${name}"
  }

  if has_key($my_hash, 'password') {
    if is_string($my_hash[password]) {
      $pass_real = $my_hash[password]
    } else {
      $pass_real = undef
    }
  } else {
    $pass_real = undef
  }

  if ($system) {
    $system_real = $system
  }

  if ($debug) {
    #To Puppetmaster
    notice("ensure    => ${ensure_real}")
    notice("uid       => ${uid_real}")
    notice("gid       => ${gid_real}")
    notice("groups    => ${groups_real}")
    notice("shell     => ${shell_real}")
    notice("home      => ${home_real}")
    notice("password  => ${pass_real}")
    notice("comment   => ${comment_real}")
    notice("system    => ${system_real}")
  }

  user { $name :
    ensure     => $ensure_real,
    uid        => $uid_real,
    gid        => $gid_real,
    groups     => $groups_real,
    shell      => $shell_real,
    home       => $home_real,
    password   => $pass_real,
    comment    => $comment_real,
    system     => $system_real,
    managehome => true,
  }

}
