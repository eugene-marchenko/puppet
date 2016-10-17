# = Define: sudo::config::sudoer
#
# This define manages sudoers files
#
# == Parameters:
#
# === Required:
#
# None.
#
# === Optional:
#
# $ensure::       Whether the grant sudoer privs to the user. Defaults to true.
#
# == Requires:
#
# sudo::package, sudo::params, stdlib
#
# == Sample Usage:
#
# Standard invocation
# sudo::config::sudoer { 'janedoe' : }
#
# Choose to remove this sudoer
# sudo::config::sudoer { 'janedoe' : ensure => 'absent'}
#
define sudo::config::sudoer(
  $ensure       = 'present',
  $sudoers_path = undef,
  $template     = '',
  $content      = '',
  $source       = [
      "puppet:///modules/sudo/${::lsbdistcodename}/${::hostname}/${name}",
      "puppet:///modules/sudo/${::lsbdistcodename}/${::role}/${name}",
      "puppet:///modules/sudo/${::lsbdistcodename}/${name}",
      "puppet:///modules/sudo/${name}",
    ],
) {

  include sudo::package
  include sudo::params
  include stdlib

  case $ensure {
    default:    { fail('Ensure must be either present or absent') }
    'present':  { $ensure_real = $ensure }
    'absent':   { $ensure_real = $ensure }
  }

  if $sudoers_path {
    $sudoers_path_real = $sudoers_path
  } else {
    $sudoers_path_real = $sudo::params::sudoers_path
  }

  case $template {
    '': {
      case $content {
        '': {
          case $source {
            '': { fail('No template, content or source specified') }
            default: { File{ source => $source} }
          }
        }
        default: { File{ content => inline_template('<%= "#{content}\n" %>')} }
      }
    }
    default: { File{ content => template($template)} }
  }

  file { "${sudoers_path_real}/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    path    => "${sudoers_path_real}/${name}",
    require => Class[sudo::package],
  }
}
