# = Class: sudo
#
# This module manages sudo and sudoers
#
# == Parameters:
#
# === Required:
#
# None.
#
# === Optional:
#
# $packageensure::      This parameter specifies whether the package is
#                       installed or not. Defaults to latest.
#
# $sudoersensure::      This parameter specifies whether the list of sudoers
#                       should be allowed or not. Defaults to present.
#
# $sudoers::            This is either an Array of sudoers users/groups or Hash.
#                       If a hash, the hashkey must be 'sudoers' and the hash
#                       value must be an Array of sudoer users/groups.
#
# $template::           The template to use for creating the sudoers file.
#                       Highest priority.
#
# $content::            Optionally you can specify the content of the sudoers
#                       file as a string. Lowest priority.
#
# == Actions:
#
# Ensures that the sudo package is either installed or not and whether the list
# of sudoers are allowed or not.
#
# == Requires:
#
# stdlib, sudo::params
#
# == Sample Usage:
#
# class { 'sudo' : }
#
# include sudo
#
# class { 'sudo' : packageensure => 'absent' }
#
# class { 'sudo' : sudoersensure => 'absent' }
#
# class { 'sudo' : packageensure => 'present' }
#
# Groups must be prefixed with '%' or else sudo will think of that as a user
# class { 'sudo' : sudoers => [ 'harry', 'frank', 'sally', '%sysadmins' ] }
#
class sudo(
  $packageensure  = hiera('sudo_packageensure'),
  $sudoersensure  = hiera('sudo_sudoersensure'),
  $sudoers        = hiera('sudoers'),
  $template       = '',
  $content        = '',
) inherits sudo::params {

  include stdlib

  Class['sudo::package'] -> Class['sudo::config']

  if $packageensure == 'absent' or $packageensure == 'purged' {
    #No point in allowing sudoers if sudo isn't installed
    $packageensure_real = $packageensure
    $sudoersensure_real = 'absent'
  } else {
    $packageensure_real = $packageensure
    $sudoersensure_real = $sudoersensure
  }

  class { 'sudo::package' :
    ensure  => $packageensure_real,
  }

  class { 'sudo::config' :
    ensure   => $sudoersensure_real,
    sudoers  => $sudoers,
    template => $template,
    content  => $content,
  }

  motd::register { 'Sudo' : }

}
