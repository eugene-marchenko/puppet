# Class: roles::logserver::jenkins
#
# This class installs logserver resources for accepting remote jenkins logs
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
# include roles::logserver
#
# class { 'roles::logserver' : }
#
#
class roles::logserver::jenkins() {

  include roles::base
  include roles::logserver

  # Get the remote log directory from parent
  $remote_log_dir = $roles::logserver::remote_log_dir

  rsyslog::config::file_monitor { 'jenkins-slaves' :
    comment                => 'Slave logs',
    input_file_name        => '/opt/jenkins/slave-Selenium.log',
    input_file_tag         => 'jenkins-slaves',
    input_file_state_file  => 'jenkins-slaves-state',
    discard     => false,
  }

  rsyslog::config::file_monitor { 'jenkins-audit' :
    comment                => 'Audit logs',
    input_file_name        => '/opt/jenkins/audit.log',
    input_file_tag         => 'jenkins-audit',
    input_file_state_file  => 'jenkins-audit-state',
    discard     => false,
  }

  # Setup log rotation
  logrotate::rule { 'jenkins-remote-syslog' :
    path          => [ "${remote_log_dir}/jenkins/*.log",
                    ],
    compress      => true,
    missingok     => true,
    rotate        => '14',
    rotate_every  => 'day',
    postrotate    => 'reload rsyslog >/dev/null 2>&1 || true',
  }

  motd::register { 'Logserver::Jenkins' : }

  # Use chaining to order the resources
  Class[roles::base]
  -> Rsyslog::Config::Property['jenkins-slaves']
  -> Rsyslog::Config::Property['jenkins-audit']
  -> Logrotate::Rule['jenkins-remote-syslog']
}
