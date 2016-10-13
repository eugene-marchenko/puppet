# Class: roles::jenkins
#
# This class installs jenkins resources
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
# include roles::jenkins
#
# class { 'roles::jenkins' : }
#
#
class roles::jenkins() {

  include roles::base

  $path = '/var/lib/jenkins'

  if ! $::aws_s3_bootstrap_access_key {
    fail('aws_s3_bootstrap_access_key fact not set')
  }

  if ! $::aws_s3_bootstrap_secret_key {
    fail('aws_s3_bootstrap_secret_key fact not set')
  }

  exec { "jenkins(mkdir -p ${path})" :
    command => "mkdir -p ${path}",
    unless  => "test -d ${path}",
  }

  exec { "jenkins(mkdir -p ${path}/backups)" :
    command => "mkdir -p ${path}/backups",
    unless  => "test -d ${path}/backups",
  }

  exec { "jenkins(get_s3_file_script)" :
    command => "wget -nv http://bootstrap.ec2.thedailybeast.com/public/ec2/s3-get-file.py -O /tmp/s3-get-file.py",
  }

  exec { "jenkins(get_s3_file)" :
    environment => [ "AWS_ACCESS_KEY_ID=${::aws_s3_bootstrap_access_key",
                    "AWS_SECRET_ACCESS_KEY=${::aws_s3_bootstrap_secret_key",
    ],
    command     => "python /tmp/s3-get-file.py -u
s3://bootstrap.ec2.thedailybeast.com/private/jenkins/jenkins-master-backup.tar.bz2
-f /tmp/jenkins-master-backup.tar.bz2 -l INFO",
  }

  exec { "jenkins(expand_backup_directory)" :
    command => "tar xvjpf /tmp/jenkins-master-backup.tar.bz2 -C /var/lib/jenkins/backups/",
  }

  exec { "jenkins(chown_backup_directory)" :
    command => "chown -R jenkins:nogroup /var/lib/jenkins/backups",
  }

  exec { "get_jenkins_restore_script" :
      command => "wget -nv https://gist.github.com/4288829/download -O /tmp/gist-jenkins_restore.tar.gz",
    }

  exec { "unpack_jenkins_restore_script" :
    command => "tar -zxvf /tmp/gist-jenkins_restore.tar.gz --wildcards gist*/jenkins_restore.py -O > /tmp/jenkins_restore.py",
  }

  exec { "jenkins(restore_jenkins_backup)" :
    command => "python -u /tmp/jenkins_restore.py --url http://localhost:8080/thinBackup/restoreOptions",
    onlyif  => "test `du -b /tmp/jenkins_restore.py | cut -f1` -gt 800",
  }

  exec { "jenkins(restart_jenkins)" :
    command => "/etc/init.d/jenkins restart",
  }

  # We need this boto version to do iops volumes
  Package <| title == 'boto' |> {
    ensure  => '2.6.0',
  }

  # Necessary dev libraries
  realize Package[libc6-i386]
  realize Package[libxml2-dev]
  realize Package[libxslt1-dev]
  realize Package[libcurl4-gnutls-dev]

  # Python Package Installs
  realize Package[BeautifulSoup]
  realize Package[jinja2]
  realize Package[lxml]
  realize Package[mechanize]
  realize Package[simplejson]
  realize Package[pysolr]
  realize Package[pycurl]
  #realize Package[pyyaml]
  realize Package[nose]
  realize Package[html2text]
  realize Package[jenkinsapi]
  realize Package[jprops]

  # lxml requires dev header libs and jenkinsapi requires lxml
  Package[libxml2-dev]
  -> Package[libxslt1-dev]
  -> Package[lxml]
  -> Package[jenkinsapi]

  # pycurl requires curl-config found in libcurl dev package
  Package[libcurl4-gnutls-dev]
  -> Package[pycurl]

  # Ensure base role installs before any of the python packages
  Class[roles::base] -> Package[BeautifulSoup]
  Class[roles::base] -> Package[jinja2]
  Class[roles::base] -> Package[lxml]
  Class[roles::base] -> Package[mechanize]
  Class[roles::base] -> Package[simplejson]
  Class[roles::base] -> Package[pysolr]
  Class[roles::base] -> Package[pycurl]
  Class[roles::base] -> Package[pyyaml]
  Class[roles::base] -> Package[nose]
  Class[roles::base] -> Package[html2text]
  Class[roles::base] -> Package[jenkinsapi]
  Class[roles::base] -> Package[jprops]

  # Java
  include java

  # Jenkins
  include jenkins::repo
  include jenkins::package
  include jenkins::service

  # Github setup
  if ! ($::github_user) {
    fail('github_user fact not set, this is needed for github authentication')
  }

  if ! ($::github_pass) {
    fail('github_pass fact not set, this is needed for github authentication')
  }

  $github_thinbackup_jpi = $::github_thinbackup_jpi ? {
    undef   => 'https://raw.githubusercontent.com/dailybeast/thin-backup-plugin/master/thinBackup.jpi',
    ''      => 'https://raw.githubusercontent.com/dailybeast/thin-backup-plugin/master/thinBackup.jpi',
    default => $::github_thinbackup_jpi,
  }

  # Jenkins plugins
  jenkins::plugin::install {
    "external-monitor-job" : ;
    "ldap" : ;
    "pam-auth" : ;
    "javadoc" : ;
    "ant" : ;
    "token-macro" : ;
    "maven-plugin" : ;
    "cvs" : ;
    "emotional-jenkins-plugin" : ;
    "locks-and-latches" : ;
    "jquery" : ;
    "run-condition" : ;
    "conditional-buildstep" : ;
    "flexible-publish" : ;
    "any-buildstep" : ;
    "job-exporter" : ;
    "build-pipeline-plugin" : ;
    "jquery-ui" : ;
    "envfile" : ;
    "console-column-plugin" : ;
    "jenkins-multijob-plugin" : ;
    "python" : ;
    "subversion" : ;
    "parameterized-trigger" : ;
    "git" : ;
    "email-ext" : ;
    "view-job-filters" : ;
    "buildresult-trigger" : ;
    "groovy-postbuild" : ;
    "extra-columns" : ;
    "github-api" : ;
    "github" : ;
    "template-project" : ;
    "scriptler" : ;
    "clone-workspace-scm" : ;
    "git-parameter" : ;
    "sloccount" : ;
    "naginator" : ;
    "preSCMbuildstep" : ;
    "copyartifact" : ;
    "batch-task" : ;
    "build-timeout" : ;
    "cobertura" : ;
    "translation" : ;
    "ssh-slaves" : ;
    "groovy" : ;
    "envinject" : ;
    "promoted-builds" : ;
    "ws-cleanup" : ;
    "mask-passwords" : ;
    "downstream-ext" : ;
    "repository" : ;
    "jenkins-cloudformation-plugin" : ;
    "extended-choice-parameter" : ;
    "gradle" : ;
    "schedule-failed-builds" : ;
    "join" : ;
    "instant-messaging" : ;
    "build-flow-plugin" : ;
    "ec2" : ;
    "nested-view" : ;
    "filesystem_scm" : ;
    "dynamicparameter" : ;
    "nodelabelparameter" : ;
    "rebuild" : ;
    "build-name-setter" : ;
    "htmlpublisher" : ;
  }

  file { '/var/lib/jenkins/plugins/thinBackup.jpi' :
      ensure  => 'present',
      path    => '/var/lib/jenkins/plugins/thinBackup.jpi',
      owner   => 'jenkins',
      group   => 'adm',
      mode    => '0644',
      content => curl($github_thinbackup_jpi,$::github_user,$::github_pass)
    }

  # Create /root/.jenkins symlink
  file { '/root/.jenkins' :
    ensure  => 'link',
    target  => '/var/lib/jenkins',
  }

  Class[roles::base]
  -> Exec["jenkins(mkdir -p ${path})"]
  -> Exec["jenkins(get_s3_file_script)"]
  -> Exec["jenkins(get_s3_file)"]
  -> Exec["jenkins(expand_backup_directory)"]
  -> Exec["jenkins(chown_backup_directory)"]
  -> File['/root/.jenkins']
  -> Package['libc6-i386']
  -> Class[java]
}
