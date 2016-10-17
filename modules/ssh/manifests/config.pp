# = Define: ssh::config
#
# This manages mail alias configurations
#
# == Parameters:
#
# === Required:
#
# $config::       A hash containing the following:
#                 $ensure
#                 $file
#                 $value
#                 $lens
#                 $require
#                 $before
#                 $notify
#
# == Actions:
#
# Sets config options for ssh, ensures that they are present or absent.
#
# == Requires:
#
# Class[ssh]
#
# == Sample Usage:
#
# Simple Change:
#
# ssh::config { 'ListenAddress' :
#   config => {
#     'ListenAddress' => {
#       ensure  => present,
#       file    => '/etc/ssh/sshd_config',
#       value   => '0.0.0.0',
#       require => Class[ssh],
#       notify  => Class[ssh::service],
#     },
#   },
# }
#
# ssh::config { 'ForwardAgent' :
#   config  => {
#     'ForwardAgent' => {
#       ensure  => absent,
#       file    => '/etc/ssh/ssh_config',
#       value   => 'no',
#       require => Class[ssh],
#     },
#   },
# }
#
# Complex change with syntax to match a Host entry where multiple are present.
#
# ssh::config { [ 'Host[. = \'*\']/ForwardAgent',
#                 'Host[. = \'foo.bar.com\' ]/ForwardX11' ] :
#   config  => {
#     'Host[. = \'*\']/ForwardAgent'          => {
#       ensure  => present,
#       file    => '/etc/ssh/ssh_config',
#       value   => 'yes',
#       require => Class[ssh],
#     },
#     'Host[. = \'foo.bar.com\']/ForwardX11'  => {
#       ensure  => present,
#       file    => '/etc/ssh/ssh_config',
#       value   => 'yes',
#       require => Class[ssh],
#     },
#   },
# }
#
#
define ssh::config(
  $config,
  $debug = false,
) {

  include stdlib
  include ssh::params

  validate_bool($debug)
  validate_hash($config)

  $my_hash = $config[$name]

  validate_hash($my_hash)

  if has_key($my_hash, 'ensure') {
    if $my_hash[ensure] in [ 'present', 'absent' ] {
      $ensure_real = $my_hash[ensure]
    } else {
      fail('ensure must be present or absent')
    }
  } else {
    $ensure_real = 'present'
  }

  if has_key($my_hash, 'file') {
    if $my_hash[file] =~ /^\// {
      $file_real = $my_hash[file]
    } else {
      fail("file: ${file_real} must be an absolute path")
    }
  } else {
    fail('file parameter must be defined')
  }

  if has_key($my_hash, 'value') {
    $value_real = $my_hash[value]
  } else {
    fail('value parameter must be defined')
  }

  if has_key($my_hash, 'lens') {
    $lens_real = $my_hash[lens]
  } else {
    $lens_real = undef
  }

  if has_key($my_hash, 'require') {
    $require_real = $my_hash[require]
  } else {
    $require_real = undef
  }

  if has_key($my_hash, 'before') {
    $before_real = $my_hash[before]
  } else {
    $before_real = undef
  }

  if has_key($my_hash, 'notify') {
    $notify_real = $my_hash[notify]
  } else {
    $notify_real = undef
  }

  if ($debug) {
    notice("ensure  => ${ensure_real}")
    notice("file    => ${file_real}")
    notice("value   => ${value_real}")
    notice("lens    => ${lens_real}")
    notice("require => ${require_real}")
    notice("before  => ${before_real}")
    notice("notify  => ${notify_real}")
  }

  if defined(File[$file_real]) {
    fail("refusing to manage ${file_real} since it's managed by File[${file_real}]")
  }

  if ($lens_real) {
    $incl_real = $file_real
  }

  if $ensure_real == present {
    augeas { "${file_real}-${name}" :
      context => "/files${file_real}",
      lens    => $lens_real,
      incl    => $incl_real,
      changes => "set ${name} '${value_real}'",
      onlyif  => "get ${name} != ${value_real}",
      require => $require_real,
      before  => $before_real,
      notify  => $notify_real,
    }
  } else {
    augeas { "${file_real}-${name}" :
      context => "/files${file_real}",
      lens    => $lens_real,
      incl    => $incl_real,
      changes => "rm ${name}",
      onlyif  => "get ${name} == ${value_real}",
      require => $require_real,
      before  => $before_real,
      notify  => $notify_real,
    }
  }
}
