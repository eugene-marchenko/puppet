# Class: roles::buildserver
#
# This class installs build server resources
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
# include roles::buildserver
#
# class { 'roles::buildserver' : }
#
#
class roles::buildserver() {

  include roles::base

  if $::build_mount_device {
    $device = $::build_mount_device
  } else {
    $device = '/dev/mapper/elastic--vol-data01'
  }

  if $::build_mount_path {
    $path = $::build_mount_path
  } else {
    $path = '/opt'
  }

  if $::build_mount_fstype {
    $fstype = $::build_mount_fstype
  } else {
    $fstype = 'xfs'
  }

  exec { "buildserver(mkdir -p ${path})" :
    command => "mkdir -p ${path}",
    unless  => "test -d ${path}",
  }

  mount { $path :
    ensure  => 'mounted',
    device  => $device,
    options => 'defaults',
    fstype  => $fstype,
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
  # realize Package[jinja2]
  realize Package[lxml]
  realize Package[mechanize]
  realize Package[simplejson]
  realize Package[pysolr]
  realize Package[pycurl]
  # realize Package[pyyaml]
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
  # Class[roles::base] -> Package[jinja2]
  Class[roles::base] -> Package[lxml]
  Class[roles::base] -> Package[mechanize]
  Class[roles::base] -> Package[simplejson]
  Class[roles::base] -> Package[pysolr]
  Class[roles::base] -> Package[pycurl]
  # Class[roles::base] -> Package[pyyaml]
  Class[roles::base] -> Package[nose]
  Class[roles::base] -> Package[html2text]
  Class[roles::base] -> Package[jenkinsapi]
  Class[roles::base] -> Package[jprops]


  rsyslog::config::file_monitor { 'jenkins-slaves' :
    comment                => 'Slave logs',
    input_file_name        => '/opt/jenkins/slave-Selenium.log',
    input_file_tag         => 'jenkins-slaves',
    input_file_state_file  => 'jenkins-slaves-state',
    discard                => false,
  }

  rsyslog::config::file_monitor { 'jenkins-audit' :
    comment                => 'Audit logs',
    input_file_name        => '/opt/jenkins/audit.log',
    input_file_tag         => 'jenkins-audit',
    input_file_state_file  => 'jenkins-audit-state',
    discard                => false,
  }

  # Java
  include java

  # Create /root/.jenkins symlink
  file { '/root/.jenkins' :
    ensure  => 'link',
    target  => '/opt/jenkins',
  }

  Class[roles::base]
  -> Exec["buildserver(mkdir -p ${path})"]
  -> Mount[$path]
  -> File['/root/.jenkins']
  -> Package['libc6-i386']
  -> Class[java]
  -> Rsyslog::Config::File_Monitor['jenkins-slaves']
  -> Rsyslog::Config::File_Monitor['jenkins-audit']

}
