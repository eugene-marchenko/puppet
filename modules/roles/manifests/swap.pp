# Class: roles::swap
#
# This is a class that simply installs a swapfile. It can then be included
# by other classes that require additional memory. This was primarily created
# for use with the collapsed_stack as running on of those services ate up more
# than 7.5GB.
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
# include roles::swap
#
# class { 'roles::swap' : }
#
#
class roles::swap() {

  include roles::base

  exec { '/mnt/swap':
    command => "/bin/dd if=/dev/zero of=/mnt/swap bs=1M count=10240",
    creates => "/mnt/swap",
  }
 
  exec { 'swapon /mnt/swap':
    command => "/sbin/mkswap /mnt/swap && /sbin/swapon /mnt/swap",
    unless => "/sbin/swapon -s | grep /mnt/swap",
  }

  Class[roles::base]
  -> Exec['/mnt/swap']
  -> Exec['swapon /mnt/swap']
 
}
