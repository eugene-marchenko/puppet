# Class: aws::ec2::security::group::export
#
#
class aws::ec2::security::group::export(
  $accesskey,
  $secretkey,
  $installed = true,
  $path      = '/usr/local/bin/export-security-groups.py',
  $template  = 'aws/ec2/security/group/export.py.erb',
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
