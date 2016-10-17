# Class: aws::ec2::ebs::snapshot
#
#
class aws::ec2::ebs::snapshot(
  $accesskey,
  $secretkey,
  $installed = true,
  $path      = '/usr/local/bin/ebs-snapshot.py',
  $template  = 'aws/ec2/ebs/snapshot.py.erb',
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
