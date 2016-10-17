# Class: cq5::taropt
#
# This class manages resources for performing tar optimization
#
# == Parameters:
#
# == Optional:
#
# $installed::      This manages whether the script is installed or not. Valid
#                   values are true and false. Defaults to true.
#
# $path::           The path of the installed script on the filesystem.
#
# $template::       The path to the script template.
#
# $source::         The puppet filebucket path to the script.
#
# $content::        The string content of the script.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# class { 'cq5::taropt' :
#   installed => false
# }
#
# class { 'cq5::taropt' :
#   source    => 'puppet::///modules/path/to/script',
# }
#
# class { 'cq5::taropt' :
#   content   => "!#/bin/bash\n...some commands",
# }
#
class cq5::taropt(
  $installed = true,
  $path      = '/usr/local/bin/cq5-tar-optimization.rb',
  $template  = '',
  $source    = 'puppet:///modules/cq5/scripts/tar-optimization.rb',
  $content   = '',
) {

  include stdlib

  validate_bool($installed)

  File {
    mode  => '0700',
    owner => 'root',
    group => 'root',
    path  => $path,
  }

  case $template {
    '': {
      case $content {
        '': {
          case $source {
            '': {
              crit('No template, source or content specified')
            }
            default: { File { source => $source } }
          }
        }
        default: { File { content => $content } }
      }
    }
    default: { File { content => template($template) } }
  }

  case $installed {
    true    : { file { $path: ensure => 'present' } }
    default : { file { $path: ensure => 'absent' } }
  }
}
