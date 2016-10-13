# Class: roles::misc::mounts
#
# This class installs miscellaneous mount resources
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::misc::mounts
#
# class { 'roles::misc::mounts' : }
#
#
class roles::misc::mounts() {

  include roles::base

  if $::misc_mount_device {
    $device = $::misc_mount_device
  } else {
    $device = '/dev/mapper/ftp-volume'
  }

  if $::misc_mount_path {
    $path = $::misc_mount_path
  } else {
    $path = '/opt'
  }

  if $::misc_mount_fstype {
    $fstype = $::misc_mount_fstype
  } else {
    $fstype = 'xfs'
  }

  exec { "misc::mounts(mkdir -p ${path})" :
    command => "mkdir -p ${path}",
    unless  => "test -d ${path}",
  }

  @mount { $path :
    ensure  => 'mounted',
    device  => $device,
    options => 'defaults',
    fstype  => $fstype,
  }

  Exec["misc::mounts(mkdir -p ${path})"]
  -> Mount[$path]

}
