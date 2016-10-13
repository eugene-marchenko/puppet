# Class: roles::cron::secgrp::check
#
# This class installs cron::secgrp::check resources
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
# include roles::cron::secgrp::check
#
# class { 'roles::cron::secgrp::check' : }
#
#
class roles::cron::secgrp::check() {

  include roles::base

  # Validate some necessary facts
  if ! $::aws_secgrp_operator_access_key {
    fail('aws_secgrp_operator_access_key fact not set')
  }

  if ! $::aws_secgrp_operator_secret_key{
    fail('aws_secgrp_operator_secret_key fact not set')
  }

  class { 'aws::ec2::security::group::check' :
    accesskey => $::aws_secgrp_operator_access_key,
    secretkey => $::aws_secgrp_operator_secret_key,
  }

  cron::crontab { 'check_secgrps' :
    command => '/usr/local/bin/check-security-groups.py',
  }

  # Use chaining to order the resources
  Class[roles::base]
  -> Class[aws::ec2::security::group::check]
  -> Cron::Crontab['check_secgrps']
}
