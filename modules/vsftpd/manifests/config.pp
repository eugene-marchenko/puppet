# Define: vsftpd::config
#
# This module installs vsftpd configs
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $configs::    The configs to install. This must be an hash of configs
#
# == Requires:
#
# stdlib, vsftpd::params
#
# == Sample Usage:
#
# vsftpd::config { 'vsftpd-configs':
#   configs => hiera('vsftpd_configs')
# }
#
define vsftpd::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'vsftpd-config' }

  create_resources(file, $configs, $defaults)

}
