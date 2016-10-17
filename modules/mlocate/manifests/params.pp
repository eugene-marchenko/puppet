# = Class: mlocate::params
#
# This module manages default parameters. It does the heavy lifting
# to determine operating system specific parameters.
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class mlocate::someclass( packages = $mlocate::params::some_param
# ) inherits mlocate::params {
# ...do something
# }
#
# class { 'mlocate::params' : }
#
# include mlocate::params
#
class mlocate::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports mlocate version >= ${supportedversion}")
}

case $::osfamily {
  /Debian/: {
    $provider       = 'apt'
    $packages       = [ 'mlocate' ]
    $packages_tag   = 'mlocate-package'
    $conf_file      = '/etc/updatedb.conf'
    $conf_tmpl      = 'mlocate/debian/updatedb.conf.erb'
    $configs_tag    = 'mlocate-config'
    $prune_paths    = [
      '/tmp',
      '/var/spool',
      '/media',
      '/home/.encrypfs',
      '/mnt',
    ]
    $prune_fs       = [
      'NFS',
      'nfs',
      'nfs4',
      'rpc_pipefs',
      'afs',
      'binfmt_misc',
      'proc',
      'smbfs',
      'autofs',
      'iso9660',
      'ncpfs',
      'coda',
      'devpts',
      'ftpfs',
      'devfs',
      'mfs',
      'shfs',
      'sysfs',
      'cifs',
      'lustre_lite',
      'tmpfs',
      'usbfs',
      'udf',
      'fuse.glusterfs',
      'fuse.sshfs',
      'curlftpfs',
      'ecryptfs',
      'fusesmb',
      'devtmpfs',
    ]
    $service_path   = '/etc/cron.daily/mlocate'
    $service_tmpl   = 'mlocate/debian/mlocate.erb'
    $service_tag    = 'mlocate-cron-service'
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
