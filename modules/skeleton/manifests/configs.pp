# Class: skeleton::configs
#
# This class installs skeleton configs
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      Boolean. Whether the configs are installed or not.
#
# $conf_file::      The conf file template to install.
#
# $defaults_conf::  The conf defaults.
#
# $configs_tag::    A tag to apply to all the config file resources.
#
# == Requires:
#
# skeleton::params
#
# == Sample Usage:
#
# include skeleton::configs
# class { 'skeleton::configs' : installed => false }
#
# class { 'skeleton::configs' :
#   conf_file  => hiera('skeleton_conf_file')
# }
#
class skeleton::configs(
  $installed      = true,
  $conf_file      = $skeleton::params::conf_file,
  $defaults_conf  = $skeleton::params::defaults_conf,
  $configs_tag    = $skeleton::params::configs_tag,
) inherits skeleton::params {

  File {
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    tag     => $configs_tag,
  }

  # For some reason tag in resource defaults doesn't work correctly in 2.7.11
  # Add it explicitly to the package resource for now until we can upgrade.
  file { '/etc/skeleton/skeleton.conf' :
    content => template($conf_file),
    tag     => $configs_tag,
  }

  file { '/etc/default/skeleton' :
    content => template($defaults_conf),
    tag     => $configs_tag,
  }

  case $installed {
    true: {}
    false: {
      File <| tag == $configs_tag |> {
        ensure  => 'absent'
      }
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
