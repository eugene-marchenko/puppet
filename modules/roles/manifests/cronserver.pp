# Class: roles::cronserver
#
# This meta class installs cron resources
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
# include roles::cronserver
#
# class { 'roles::cronserver' : }
#
#
class roles::cronserver() {

#  include roles::cron::snapshot::rotator
  include roles::cron::mysql::backups
  include roles::cron::analytics
  include roles::cron::secgrp::check
  include roles::cron::secgrp::export
  include roles::cron::digital
  include roles::cron::github

}
