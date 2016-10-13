# Class: roles::cron::github
#
# This class installs the github script/crontab and necessary supporting modules
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
# include roles::cron::github
#
# class { 'roles::cron::github' : }
#
#
class roles::cron::github() {

  include roles::base

  # Validate some necessary facts
  if $::github_user {
    $user = $::github_user
  } else {
    fail('github_user fact not set')
  }

  if $::github_pass {
    $pass = $::github_pass
  } else {
    fail('github_pass fact not set')
  }

  # Set File resource defaults
  File {
    ensure  => 'present',
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
  }

  # Install files
  file { '/usr/local/bin/github.py':
    path   => '/usr/local/bin/github.py',
    source => 'puppet:///modules/data/scripts/github/github.py',
  }

  # Realize any required virtual packages
  realize Package['requests']

  # Specify crontabs
  cron::crontab { 'github_gists_purge' :
    environment => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command     => "github.py -u ${user} -p ${pass} gist list -p 10 -e 25 |
    cut -f 2 -d ' ' | xargs -I {} github.py -u ${user} -p ${pass} gist del {} |
    logger -t github"
  }

  # Specify resource ordering
  Class[roles::base]
  -> Package['requests']
  -> File['/usr/local/bin/github.py']
  -> Cron::Crontab['github_gists_purge']

}
