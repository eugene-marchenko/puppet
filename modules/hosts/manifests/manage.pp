# Define: hosts::manage
#
# This define manages hosts manages
#
# == Parameters:
#
# == Required:
#
# $ip::             The ip address of the host entry.
#
# == Optional:
#
# $ensure::         Whether the manage is present on the system or not. If set
#                   to false it will remove the entry from the hosts file.
#
# $host_aliases::   An Array of host aliases to append to the entry.
#
# $comment::        An optional comment explaining the hosts entry.
#
# == Requires:
#
# stdlib, hosts::params
#
# == Sample Usage:
#
# hosts::manage { 'server1.example.com':
#   ip            => '127.0.0.1',
#   host_aliases  => [ 'server1', 'srv1' ]
#   comment       => 'Add human readable servername'
# }
#
define hosts::manage(
  $ip,
  $host_aliases = [],
  $ensure  = true,
  $comment = undef,
) {

  include stdlib

  validate_bool($ensure)
  validate_array($host_aliases)

  case $ensure {
    true: {
      $ensure_real = 'present'
    }
    false: {
      $ensure_real = 'absent'
    }
    default: {}
  }

  host { $name :
    ensure       => $ensure_real,
    ip           => $ip,
    host_aliases => $host_aliases,
    comment      => $comment,
  }

}
