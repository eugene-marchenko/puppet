# Class: roles::cron::analytics
#
# This class installs the password vault utility w3pw and necessary vhosts
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
# include roles::cron::analytics
#
# class { 'roles::cron::analytics' : }
#
#
class roles::cron::analytics() {

  include roles::base
  include roles::backports

  # Validate some necessary facts
  if ! $::cron::nw_analytics_omniture_user {
    fail('nw_analytics_omniture_user fact not set')
  }

  if ! $::cron::nw_analytics_omniture_pass {
    fail('nw_analytics_omniture_pass fact not set')
  }

  if ! $::cron::nw_analytics_aws_access_key {
    fail('nw_analytics_aws_access_key fact not set')
  }

  if ! $::cron::nw_analytics_aws_secret_key {
    fail('nw_analytics_aws_secret_key fact not set')
  }

  include java
  include nw_analytics

# disable the nw-analytics cron
#  cron::crontab { 'nw-analytics' :
#    minute  => '0',
#    hour    => '09',
#    command => '/usr/bin/FetchWebLogsAndGenerateRecommendedLinksJavascriptFile.sh | logger -t nw-analytics',
#  }

  # Anchor the class
  Class[roles::base]
  -> Class[java]
  -> Class[nw_analytics]
#  -> Cron::Crontab['nw-analytics']

}
