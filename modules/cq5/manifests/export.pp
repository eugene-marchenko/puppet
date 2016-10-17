# Class: cq5::export
#
# This class manages resources for exporting cq5 content as packages
#
# == Parameters:
#
# == Required:
#
# $accesskey::      The AWS AccessKeyID for S3 upload access.
#
# $secretkey::      The AWS SecretAccessKeyID for S3 upload access.
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
# class { 'cq5' : accesskey => 'AAa...', secretkey => 'ae124...' }
#
# class { 'cq5' :
#   accesskey => 'AAa...',
#   secretkey => 'ae124...',
#   installed => false
# }
#
# class { 'cq5' :
#   accesskey => 'AAa...',
#   secretkey => 'ae124...',
#   source    => 'puppet::///modules/path/to/script',
# }
#
# class { 'cq5' :
#   accesskey => 'AAa...',
#   secretkey => 'ae124...',
#   content   => "!#/bin/bash\n...some commands",
# }
#
class cq5::export(
  $accesskey,
  $secretkey,
  $installed = true,
  $path      = '/usr/local/bin/cq5-export-package.py',
  $template  = 'cq5/scripts/cq5-export-package.py.erb',
  $source    = '',
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

  case $source {
    '': {
      case $content {
        '': {
          case $template {
            '': {
              crit('No template, source or content specified')
            }
            default: { File { content => template($template) } }
          }
        }
        default: { File { content => $content } }
      }
    }
    default: { File { source => $source } }
  }

  case $installed {
    true    : { file { $path: ensure => 'present' } }
    default : { file { $path: ensure => 'absent' } }
  }
}
