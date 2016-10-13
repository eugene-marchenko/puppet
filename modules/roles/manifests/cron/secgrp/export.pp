# Class: roles::cron::secgrp::export
#
# This class installs cron::secgrp::export resources
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
# include roles::cron::secgrp::export
#
# class { 'roles::cron::secgrp::export' : }
#
#
class roles::cron::secgrp::export() {

  include roles::base

  # Validate some necessary facts
  if ! $::aws_secgrp_operator_access_key {
    fail('aws_secgrp_operator_access_key fact not set')
  }

  if ! $::aws_secgrp_operator_secret_key{
    fail('aws_secgrp_operator_secret_key fact not set')
  }

  class { 'aws::ec2::security::group::export' :
    accesskey => $::aws_secgrp_operator_access_key,
    secretkey => $::aws_secgrp_operator_secret_key,
  }

  cron::crontab { 'export_secgrps' :
    minute  => '57',
    command => '/usr/local/bin/export-security-groups.py -f /tmp/secgrp.txt',
  }

  cron::crontab { 'diff_secgrps' :
    command => '/usr/local/bin/export-security-groups.py -f /tmp/secgrp.txt -d',
  }

  # Use chaining to order the resources
  Class[roles::base]
  -> Class[aws::ec2::security::group::export]
  -> Cron::Crontab['diff_secgrps']
  -> Cron::Crontab['export_secgrps']
}
