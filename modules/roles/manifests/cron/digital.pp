# Class: roles::cron::digital
#
# This class installs the password vault utility, and necessary vhosts, and other scripts that need to be run on the cronserver
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
# include roles::cron::digital
#
# class { 'roles::cron::digital' : }
#
#
class roles::cron::digital() {

  include roles::base

  # Set File resource defaults
  File {
    ensure  => 'present',
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
  }

  # Install files
  #file { '/opt/yourrepsonguns':
  #  source  => 'puppet:///modules/data/scripts/digital/yourrepsonguns',
  #  ensure  => 'directory',
  #  recurse => true,
  #}
  file { '/opt/whitelister':
    ensure  => 'directory',
    source  => 'puppet:///modules/data/scripts/digital/whitelister',
    recurse => true,
  }


  #exec { 'touch /opt/yourrepsonguns/last_successful_id.txt':
  #  command => 'touch /opt/yourrepsonguns/last_successful_id.txt',
  #  unless  => 'test -f /opt/yourrepsonguns/last_successful_id.txt',
  #}

  # Realize any required virtual packages
  #realize Package['oauth2']
  #realize Package['tweepy']
  #realize Package['cartodb']
  #realize Package['boto']
  realize Package['urllib3']
  realize Package['slacker']

  # Specify crontabs
  #cron::crontab { 'repsguntweets' :
  #  minute      => '*/5',
  #  hour        => '*',
  #  command     => '/opt/yourrepsonguns/yourrepsonguns.sh | logger -t repsguntweets',
  #}
  cron::crontab { 'whitelister':
      minute  => '*/30',
      hour    => '*',
      command => 'python /opt/whitelister/whitelist.py >> /opt/whitelister/whitelister.log',
  }

  # Specify resource ordering
  Class[roles::base]
  #-> Package['oauth2']
  #-> Package['tweepy']
  #-> Package['cartodb']
  #-> File['/opt/yourrepsonguns']
  #-> Exec['touch /opt/yourrepsonguns/last_successful_id.txt']
  #-> Cron::Crontab['repsguntweets']
  -> Package['urllib3']
  -> Package['slacker']
  -> File['/opt/whitelister']
  -> Cron::Crontab['whitelister']
}
