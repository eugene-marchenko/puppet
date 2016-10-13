# Class: roles::cq5::publish
#
# This class installs cq5::publish resources
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
# include roles::cq5::publish
#
# class { 'roles::cq5::publish' : }
#
#
class roles::cq5::publish() {

  include roles::base
  include roles::params
  include roles::cq5::jvm

  if $::publish_ephemeral_mount {
    $publish_ephemeral_mount = $::publish_ephemeral_mount
  } else {
    $publish_ephemeral_mount = '/mnt'
  }

  # Check if provided ephemeral mount is actually a mountpoint, else it's on the
  # root volume and a swapfile would take up too much space. This is a hack
  # since some instances don't have ephemeral storage.
  #
  # TODO: Should probably create a function for this
  # TODO: Below DOES NOT work since this runs on the puppetmaster, not on the
  #       client
  #if inline_template("<%= require 'pathname';
  #    Pathname.new(publish_ephemeral_mount).mountpoint? %>") == "true" {
  #  include roles::swap
  #  debug("${publish_ephemeral_mount} is mounted on ${hostname}!")
  #} else {
  #  debug("${publish_ephemeral_mount} is NOT mounted on ${hostname}!")
  #}

  if $::cq5_env {
    $cq5_env = $::cq5_env
  } elsif $::env {
    $cq5_env = $::env
  } else {
    fail('cq5_env nor env fact is set')
  }

  if $::cq5_pass {
    $cq5_pass = $::cq5_pass
  } else {
    fail('cq5_pass fact not set')
  }

  if $::cq5_publish_path {
    $cq5_publish_path = $::cq5_publish_path
  } else {
    $cq5_publish_path = '/opt/cq5/publish'
  }

  if $::cq5_publish_port {
    $cq5_publish_port = $::cq5_publish_port
  } else {
    $cq5_publish_port = '8080'
  }

  if $::cq5_publish_max_heap {
    $cq5_publish_max_heap = $::cq5_publish_max_heap
  } else {
    $cq5_publish_max_heap = '2048'
  }

  if $::cq5_publish_max_files {
    $cq5_publish_max_files = $::cq5_publish_max_files
  } else {
    $cq5_publish_max_files = '65535'
  }

  if $::cq5_publish_javaopts {
    $cq5_publish_javaopts = $::cq5_publish_javaopts
  } else {
    $cq5_publish_javaopts = '-Dcom.day.crx.persistence.tar.IndexMergeDelay=0'
  }

  if $::cq5_publish_mount_path {
    $cq5_publish_mount_path = $::cq5_publish_mount_path
  } else {
    $cq5_publish_mount_path = '/opt/cq5/publish'
  }

  if $::cq5_publish_mount_device {
    $cq5_publish_mount_device = $::cq5_publish_mount_device
  } else {
    $cq5_publish_mount_device = '/dev/mapper/publish1-volume'
  }

  if $::cq5_publish_mount_fstype {
    $cq5_publish_mount_fstype = $::cq5_publish_mount_fstype
  } else {
    $cq5_publish_mount_fstype = 'xfs'
  }

  if $::cq5_publish_datastoregc_enabled {
    $cq5_publish_datastoregc_enabled = str2bool($::cq5_publish_datastoregc_enabled)
  } else {
    $cq5_publish_datastoregc_enabled = false
  }

  include cq5

  exec { "cq5::publish(mkdir -p ${cq5_publish_mount_path})" :
    command => "mkdir -p ${cq5_publish_mount_path}",
    unless  => "test -d ${cq5_publish_mount_path}",
  }

  mount { $cq5_publish_mount_path :
    ensure  => 'mounted',
    device  => $cq5_publish_mount_device,
    options => 'defaults',
    fstype  => $cq5_publish_mount_fstype,
  }

  cq5::node { 'publish' :
    port          => $cq5_publish_port,
    path          => $cq5_publish_path,
    mount         => $cq5_publish_mount_path,
    env           => $env,
    cq5_env       => $cq5_env,
    role          => 'publish',
    heap_min      => $cq5_publish_max_heap,
    heap_max      => $cq5_publish_max_heap,
    max_files     => $cq5_publish_max_files,
    javaopts      => $cq5_publish_javaopts,
  }

  # Get Region info
  $region = regsubst($::ec2_placement_availability_zone, '^(us|sa|eu|ap)-(north|northeast|south|southeast|east|west)-([0-9]+)[a-z]$', '\1-\2-\3')
  cron::crontab { 'ebs_snapshot_hourly_publish' :
    minute  => fqdn_rand(60),
    hour    => '*/1',
    command => "sync && /usr/local/bin/ebs-snapshot.py -r ${region} -t 24H instance -i ${::ec2_instance_id}",
  }

  # cut the startup log down to a managable size
  cron::crontab { 'truncate_cq5_startup_log' :
    minute  => '0',
    hour    => '6',
    command => "/usr/bin/truncate --size 100M /opt/cq5/publish/crx-quickstart/server/logs/startup.log",
  }

  if $cq5_env =~ /prod|production/ {
    Cron::Crontab <| title == 'ebs_snapshot_hourly_publish' |> {
      installed => false
    }
  } else {
    Cron::Crontab <| title == 'ebs_snapshot_hourly_publish' |> {
      installed => false
    }
  }

  # Datastore GC
  realize Package[libcurl4-gnutls-dev]
  realize Package[curb]

  include cq5::datastoregc

  cron::crontab { 'datastore_gc_publish' :
    enabled     => $cq5_publish_datastoregc_enabled,
    minute      => '0',
    hour        => '8',
    day_of_week => fqdn_rand(7),
    command     => "/usr/local/bin/cq5-datastore-gc.rb --host localhost --port ${cq5_publish_port} --pass ${cq5_pass} -d -s 2 -l DEBUG | logger -t cq5-datastore-gc",
  }

  if ( $::env != prod ) {
    sudo::config::sudoer { 'jenkins-publish':
      content => 'jenkins ALL=NOPASSWD: ALL',
    }
  }

  Class[roles::base]
  ->  Exec["cq5::publish(mkdir -p ${cq5_publish_mount_path})"]
  ->  Mount[$cq5_publish_mount_path]
  ->  Cron::Crontab['ebs_snapshot_hourly_publish']
  ->  Class[roles::cq5::jvm]
  ->  Class[cq5]
  ->  Cq5::Node[publish]
  ->  Package[libcurl4-gnutls-dev]
  ->  Package[curb]
  ->  Class[cq5::datastoregc]
  ->  Cron::Crontab['datastore_gc_publish']
  ->  Cron::Crontab['truncate_cq5_startup_log']

}
