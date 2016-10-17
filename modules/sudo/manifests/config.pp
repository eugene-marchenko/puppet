# = Class: sudo::config
#
# This class ensures the sudoers file
#
# == Parameters:
#
# === Required:
#
# None.
#
# === Optional:
#
# $ensure::       Whether to ensure the sudoers have sudo privs. Defaults to
#                 present.
#
# $sudoers::      An array containing groups or users allowed to sudo. Default
#                 is [ 'sysadmins' ].
#
# $template::     The template to use for creating the sudoers file. Highest
#                 priority.
#
# $content::      Optionally you can specify the content of the sudoers file
#                 as a string. Lowest priority.
#
# == Requires:
#
# sudo::package
# stdlib
#
# == Sample Usage:
#
# Parameterized class invocation
# class { 'sudo::config' : }
#
# Standard invocation
# include sudo::config
#
# Choose not to ensure these sudoers
# class { 'sudo::config' : ensure => 'absent' }
#
# Input a different sudoers array
# class { 'sudo::config' : sudoers => [ 'janedoe', 'marlow' ] }
class sudo::config(
  $ensure = 'present',
  $sudoers = hiera('sudoers'),
  $template = '',
  $content = '',
) inherits sudo::params {

  include stdlib

  if is_hash($sudoers) {
    $sudoers_real = $sudoers[sudoers]
  } else {
    $sudoers_real = $sudoers
  }

  validate_array($sudoers_real)

  sudo::config::sudoer { $sudoers_real :
    ensure   => $ensure,
    template => $template,
    content  => $content,
  }
}
