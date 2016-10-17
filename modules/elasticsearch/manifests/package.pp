# == Class: elasticsearch::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'elasticsearch::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class elasticsearch::package {

  #### Package management

  # set params: in operation
  if $elasticsearch::ensure == 'present' {

    $package_ensure = $elasticsearch::autoupgrade ? {
      true  => 'latest',
      false => 'present',
    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  if $elasticsearch::pkg_source {

    $filenameArray = split($elasticsearch::pkg_source, '/')
    $basefilename = $filenameArray[-1]

    $extArray = split($basefilename, '\.')
    $ext = $extArray[-1]

    $tmpSource = "/tmp/${basefilename}"

    file { $tmpSource:
      source => $elasticsearch::pkg_source,
      owner  => 'root',
      group  => 'root'
    }

    case $ext {
      'deb':   { $pkg_provider = 'dpkg' }
      'rpm':   { $pkg_provider = 'rpm'  }
      default: { fail("Unknown file extention \"${ext}\"") }
    }
  } else {
    $tmpSource = undef
    $pkg_provider = undef
  }

  file { 'es_install':
    mode   => '0755',
    owner  => root,
    group  => root,
    path   => '/tmp/es_install.sh',
    source => 'puppet:///modules/elasticsearch/es_install.sh'
  }

  file { 'es_config':
      mode   => '0644',
      owner  => root,
      group  => root,
      ensure => present,
      path   => '/usr/local/share/elasticsearch/config/elasticsearch.yml',
      source => 'puppet:///modules/elasticsearch/elasticsearch.yml',
  }

  file { 'es_init':
      mode   => '0755',
      owner  => root,
      group  => root,
      ensure => present,
      path   => '/etc/init.d/elasticsearch',
      source => 'puppet:///modules/elasticsearch/elasticsearch.init',
  }

  file { 'es_template':
      mode   => '0644',
      owner  => root,
      group  => root,
      ensure => present,
      path   => '/tmp/logstash-template.json',
      source => 'puppet:///modules/elasticsearch/logstash-template.json',
  }

  exec { 'es_install':
    cwd       => '/tmp',
    command   => '/tmp/es_install.sh',
    logoutput => 'on_failure',
  }

}
