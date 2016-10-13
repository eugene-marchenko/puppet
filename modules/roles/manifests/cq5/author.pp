# Class: roles::cq5::author
#
# This class installs cq5::author resources
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
# include roles::cq5::author
#
# class { 'roles::cq5::author' : }
#
#
class roles::cq5::author() {

  include roles::base
  include roles::params
  include roles::cq5::jvm
  include newrelic

  # Validate some necessary facts
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

  if ! $::aws_s3_db_backup_access_key {
    fail('aws_s3_db_backup_access_key fact not set')
  }

  if ! $::aws_s3_db_backup_secret_key {
    fail('aws_s3_db_backup_secret_key fact not set')
  }

  # Validate some optional facts
  if $::cq5_author_path {
    $cq5_author_path = $::cq5_author_path
  } else {
    $cq5_author_path = '/opt/cq5/author'
  }

  if $::cq5_author_port {
    $cq5_author_port = $::cq5_author_port
  } else {
    $cq5_author_port = '8080'
  }

  if $::cq5_author_max_heap {
    $cq5_author_max_heap = $::cq5_author_max_heap
  } else {
    $cq5_author_max_heap = '2048'
  }

  if $::cq5_author_max_files {
    $cq5_author_max_files = $::cq5_author_max_files
  } else {
    $cq5_author_max_files = '65535'
  }

  if $::cq5_author_javaopts {
    $cq5_author_javaopts = $::cq5_author_javaopts
  } else {
    $cq5_author_javaopts = '-Dcom.day.crx.persistence.tar.IndexMergeDelay=0'
  }

  if $::cq5_author_mount_path {
    $cq5_author_mount_path = $::cq5_author_mount_path
  } else {
    $cq5_author_mount_path = '/opt/cq5/author'
  }

  if $::cq5_author_mount_device {
    $cq5_author_mount_device = $::cq5_author_mount_device
  } else {
    $cq5_author_mount_device = '/dev/mapper/elastic_drive-volume'
  }

  if $::cq5_author_mount_fstype {
    $cq5_author_mount_fstype = $::cq5_author_mount_fstype
  } else {
    $cq5_author_mount_fstype = 'xfs'
  }

  if $::cq5_author_datastoregc_enabled {
    $cq5_author_datastoregc_enabled = str2bool($::cq5_author_datastoregc_enabled)
  } else {
    $cq5_author_datastoregc_enabled = false
  }

  if $::cq5_author_tarpm_opt_enabled {
    $cq5_author_tarpm_opt_enabled = str2bool($::cq5_author_tarpm_opt_enabled)
  } else {
    $cq5_author_tarpm_opt_enabled = false
  }

  include cq5

  exec { "cq5::author(mkdir -p ${cq5_author_mount_path})" :
    command => "mkdir -p ${cq5_author_mount_path}",
    unless  => "test -d ${cq5_author_mount_path}",
  }

  mount { $cq5_author_mount_path :
    ensure  => 'mounted',
    device  => $cq5_author_mount_device,
    options => 'defaults',
    fstype  => $cq5_author_mount_fstype,
  }

  cq5::node { 'author' :
    port          => $cq5_author_port,
    path          => $cq5_author_path,
    mount         => $cq5_author_mount_path,
    env           => $env,
    cq5_env       => $cq5_env,
    role          => 'author',
    heap_min      => $cq5_author_max_heap,
    heap_max      => $cq5_author_max_heap,
    max_files     => $cq5_author_max_files,
    javaopts      => $cq5_author_javaopts,
  }

  # Get Region info
  $region = regsubst($::ec2_placement_availability_zone, '^(us|sa|eu|ap)-(northeast|north|south|southeast|east|west)-([0-9]+)[a-z]$', '\1-\2-\3')
  cron::crontab { 'ebs_snapshot_hourly_author' :
    minute  => '0',
    hour    => '*/1',
    command => "sync && /usr/local/bin/ebs-snapshot.py -r ${region} -t 24H instance -i ${::ec2_instance_id}",
  }

  if $cq5_env =~ /prod|production/ {
    Cron::Crontab <| title == 'ebs_snapshot_hourly_author' |> {
      installed => false
    }
  } else {
    Cron::Crontab <| title == 'ebs_snapshot_hourly_author' |> {
      installed => false
    }
  }

  class { 'cq5::export' :
    accesskey => $::aws_s3_db_backup_access_key,
    secretkey => $::aws_s3_db_backup_secret_key,
  }

#  cron::crontab { 'cat_author_index_tar' :
#    minute      => [fqdn_rand(30), ',', fqdn_rand(30) + 30],
#    command     => "find ${cq5_author_path}/crx-quickstart/repository/workspaces/crx.default -name '*.tar' -exec cat {} > /dev/null \;"
#  }

  cron::crontab { 'cq5_backup_users' :
    minute      => '5',
    hour        => '10',
    environment => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command     => "/usr/local/bin/cq5-export-package.py -p /home -e /home/a/admin --environment ${cq5_env} --host ${::fqdn} --port ${cq5_author_port} --pass ${cq5_pass} -n account_backup -b nw-backups",
  }

  # Datastore GC
  realize Package[libcurl4-gnutls-dev]
  realize Package[curb]

  include cq5::datastoregc

  cron::crontab { 'datastore_gc_author' :
    enabled     => $cq5_author_datastoregc_enabled,
#    minute      => fqdn_rand(60),
#    hour        => fqdn_rand(24),
#    day_of_week => fqdn_rand(7),
    minute      => '0',
    hour        => '13',
    day_of_week => '0',
    command     => "/usr/local/bin/cq5-datastore-gc.rb --host localhost --port ${cq5_author_port} --pass ${cq5_pass} -d -s 2 -l DEBUG | logger -t cq5-datastore-gc",
  }

  # TarPM Optimization
  realize Package[libxml2-dev]
  realize Package[libxslt1-dev]
  Package <| title == 'nokogiri' |> {
    ensure  => '1.5.9'
  }

  include cq5::taropt

  cron::crontab { 'tarpm_opt_author' :
    enabled     => $cq5_author_tarpm_opt_enabled,
#    minute      => fqdn_rand(60,30),
#    hour        => fqdn_rand(24,30),
#    day_of_week => fqdn_rand(7,30),
    minute      => '0',
    hour        => '2',
    day_of_week => '0',
    command     => "/usr/local/bin/cq5-tar-optimization.rb --host localhost --port ${cq5_author_port} --pass ${cq5_pass} --action start -l DEBUG | logger -t cq5-tar-optimization",
  }

  # Audit Purge
#  cron::crontab { 'audit_node_purge_author' :
#    minute  => '0',
#    hour    => '4',
#    command => "touch ${cq5_author_path}/cleanAudit",
#  }

  if ( $::env != prod ) {
    sudo::config::sudoer { 'jenkins-author':
      content => 'jenkins ALL=NOPASSWD: ALL',
    }
  }

  
  Class[roles::base]
  ->  Exec["cq5::author(mkdir -p ${cq5_author_mount_path})"]
  ->  Mount[$cq5_author_mount_path]
  ->  Class[roles::cq5::jvm]
  ->  Cron::Crontab['ebs_snapshot_hourly_author']
  ->  Class[cq5]
  ->  Cq5::Node[author]
  ->  Class[cq5::export]
#  ->  Cron::Crontab['cat_author_index_tar']
  ->  Cron::Crontab['cq5_backup_users']
  ->  Package[libcurl4-gnutls-dev]
  ->  Package[curb]
  ->  Class[cq5::datastoregc]
  ->  Cron::Crontab['datastore_gc_author']
  ->  Package[libxml2-dev]
  ->  Package[libxslt1-dev]
  ->  Package[nokogiri]
  ->  Class[cq5::taropt]
  ->  Cron::Crontab['tarpm_opt_author']
#  ->  Cron::Crontab['audit_node_purge_author']
}
