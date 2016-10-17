# Define: sysctl::option
#
# This define manages sysctl options
#
# == Parameters:
#
# == Required:
#
# $value::      The option name's value.
#
# == Optional:
#
# $ensure::     Whether the option is present on the system or not. **Note**
#               this will not magically reset the option to the system's
#               preconfigured option...yet.
#
# $comment::    An optional comment explaining the sysctl option.
#
# == Requires:
#
# stdlib, sysctl::params
#
# == Sample Usage:
#
# sysctl::option { 'net.ipv4.ip_local_port_range':
#   value   => '1024 65535'
#   comment => '# Caching server performance tuning'
# }
#
define sysctl::option(
  $value,
  $ensure  = true,
  $comment = undef,
) {

  include sysctl::params
  include stdlib

  $sysctl_dot_dir = $sysctl::params::sysctl_dot_dir
  $sysctl_option_template = $sysctl::params::sysctl_option_template

  validate_bool($ensure)

  case $ensure {
    true: {
      $ensure_real = 'present'
    }
    false: {
      $ensure_real = 'absent'
    }
    default: {}
  }

  $config = {}
  $config["${sysctl_dot_dir}/60-${name}.conf"] = {
    'ensure'  => $ensure_real,
    'owner'   => 'root',
    'group'   => 'root',
    'mode'    => '0644',
    'content' => template($sysctl_option_template),
  }

  sysctl::config { $name: configs => $config }

  if defined(Class[sysctl::service]) {
    Sysctl::Config[$name] ~> Class[sysctl::service]
  }
}
