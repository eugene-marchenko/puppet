# Class: roles::ftpserver
#
# This class installs ftpserver resources
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
# include roles::ftpserver
#
# class { 'roles::ftpserver' : }
#
#
class roles::ftpserver() {

  include roles::base

  include roles::misc::mounts
  Mount <| title == "$roles::misc::mounts::path" |>

  include vsftpd
  users::manage::group { 'ftpusers' : }
  users::manage { 'ftpusers' : override => true, manage_ssh => false }

  file { '/opt/ftp' :
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  Class[roles::base]
  -> Mount[$roles::misc::mounts::path]
  -> Class[vsftpd]
  -> Users::Manage::Group[ftpusers]
  -> File['/opt/ftp']
  -> Users::Manage[ftpusers]
}
