# = Define: users::manage::sshkey
#
# This manages a specific user's ssh key
#
# == Parameters:
#
# === Required:
#
# === Optional:
#
# $config::     A hash containing the following:
#               $ensure:      Valid values => String 'present or 'absent'
#               $ssh_key:     Valid values => String
#
# $ensure::     Overrides the $ensure parameter specified in the $config hash.
#               Defaults to present.
#
# $debug::      Whether to enable debug notices/notifies. Defaults to false.
#
# == Actions:
#
# Ensures the user's ssh key is either present or not.
#
# == Requires:
#
# == Sample Usage:
#
# A typical regular user's key:
# users::manage::sshkey { 'johndoe' :
#   config => {
#     'johndoe' =>
#       {
#       'ssh_pub_key_ensure'  => 'present',
#       'ssh_pub_key'         => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ...',
#       'ssh_pub_key_type     => 'ssh-rsa',
#       'ssh_pub_key_options  => '',
#       },
#   },
# }
#
# A key that is forced to be absent:
# users::manage::sshkey { 'johndoe' :
#   config => {
#     'johndoe' =>
#       {
#       'ssh_pub_key_ensure'    => 'present',
#       'ssh_pub_key'           => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ...',
#       'ssh_pub_key_type'      => 'ssh-dss',
#       'ssh_pub_key_options    => '',
#       },
#   },
#   ensure => 'absent',
# }
#
# A key with no config, lookup done by hiera
# users::manage::sshkey { 'johndoe' : }
#
define users::manage::sshkey(
  $config = undef,
  $ensure = 'present',
  $debug  = false,
) {

  include stdlib

  validate_bool($debug)

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
    if has_key($my_hash, 'ssh_pub_key_ensure') {
      if $my_hash[ssh_pub_key_ensure] in [ 'present', 'absent' ] {
        $ensure_real = $my_hash[ssh_pub_key_ensure]
      } else {
        fail('ensure value must be present or absent')
      }
    } else {
      $ensure_real = 'present'
    }
  }

  if has_key($my_hash, 'ssh_pub_key') {
    if is_string($my_hash[ssh_pub_key]) {
      $key_real = $my_hash[ssh_pub_key]
    } else {
      fail('ssh key is not a String')
    }
  } else {
    $key_real = undef
  }

  if has_key($my_hash, 'ssh_pub_key_type') {
    if $my_hash[ssh_pub_key_type] in [ 'ssh-dss', 'ssh-rsa' ] {
      $type_real = $my_hash[ssh_pub_key_type]
    } else {
      fail('ssh key type is not one of ssh-dss or ssh-rsa')
    }
  } else {
    $type_real = undef
  }

  if has_key($my_hash, 'ssh_pub_key_user') {
    if ! empty($my_hash[ssh_pub_key_user]) {
      $user_real = $my_hash[ssh_pub_key_user]
    } else {
      $user_real = $name
    }
  } else {
    $user_real = $name
  }

  if has_key($my_hash, 'ssh_pub_key_options') {
    if ! empty($my_hash[ssh_pub_key_options]) {
      $options_real = $my_hash[ssh_pub_key_options]
    } else {
      $options_real = undef
    }
  } else {
    $options_real = undef
  }

  if has_key($my_hash, 'ssh_pub_key_target') {
    if ! empty($my_hash[ssh_pub_key_target]) {
      $target_real = $my_hash[ssh_pub_key_target]
    } else {
      $target_real = undef
    }
  } else {
    $target_real = undef
  }

  if ($debug) {
    #To Puppetmaster
    notice("ensure    => ${ensure_real}")
    notice("user      => ${user_real}")
    notice("key       => ${key_real}")
    notice("type      => ${type_real}")
    notice("options   => ${options_real}")
    notice("target    => ${target_real}")
  }

  ssh_authorized_key { $name :
    ensure  => $ensure_real,
    user    => $user_real,
    key     => $key_real,
    type    => $type_real,
    options => $options_real,
    target  => $target_real,
  }

}
