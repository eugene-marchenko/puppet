# Class: roles::cron::snapshot::rotator
#
# This class installs cron::snapshot::rotator resources
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
# include roles::cron::snapshot::rotator
#
# class { 'roles::cron::snapshot::rotator' : }
#
#
class roles::cron::snapshot::rotator() {

  include roles::base

  # Validate some necessary facts
  if ! $::aws_snap_rotator_access_key {
    fail('aws_snap_rotator_access_key fact not set')
  }

  if ! $::aws_snap_rotator_secret_key {
    fail('aws_snap_rotator_secret_key fact not set')
  }

  class { 'aws::ec2::ebs::snapshot::rotation' :
    accesskey => $::aws_snap_rotator_access_key,
    secretkey => $::aws_snap_rotator_secret_key,
  }

  cron::crontab { 'rotate_snapshots_us_east_1' :
    hour    => '*/1',
    command => '/usr/local/bin/snapshot-rotation.py -r us-east-1',
  }

  cron::crontab { 'rotate_snapshots_us_west_2' :
    hour    => '*/1',
    command => '/usr/local/bin/snapshot-rotation.py -r us-west-2',
  }


  # Use chaining to order the resources
  Class[roles::base]
  -> Class[aws::ec2::ebs::snapshot::rotation]
  -> Cron::Crontab['rotate_snapshots_us_east_1']
  -> Cron::Crontab['rotate_snapshots_us_west_2']
}
