# Class: mlocate::configs
#
# This class installs mlocate configs
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::          Boolean. Whether the configs are installed or not.
#
# $conf_file::          The conf file path on the filesystem.
#
# $conf_tmpl::          The conf file template.
#
# $configs_tag::        A tag to apply to all the config file resources.
#
# $prune_bind_mounts::  Whether to scan bind mounts or not. Default true.
#
# $prune_names::        A list of directory names (without paths) which should
#                       not be scanned.
#
# $prune_paths::        A list of path names of directories which should not be
#                       scanned.
#
# $prune_fs::           A list of file system types which should not be scanned.
#
# == Requires:
#
# mlocate::params
#
# == Sample Usage:
#
# include mlocate::configs
# class { 'mlocate::configs' : installed => false }
#
# class { 'mlocate::configs' :
#   conf_file  => hiera('mlocate_conf_file')
# }
#
class mlocate::configs(
  $installed          = true,
  $conf_file          = $mlocate::params::conf_file,
  $conf_tmpl          = $mlocate::params::conf_tmpl,
  $configs_tag        = $mlocate::params::configs_tag,
  $prune_bind_mounts  = true,
  $prune_names        = undef,
  $prune_paths        = $mlocate::params::prune_paths,
  $prune_fs           = $mlocate::params::prune_fs,
) inherits mlocate::params {

  File {
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    tag     => $configs_tag,
  }

  # For some reason tag in resource defaults doesn't work correctly in 2.7.11
  # Add it explicitly to the package resource for now until we can upgrade.
  file { $conf_file :
    path    => $conf_file,
    content => template($conf_tmpl),
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
