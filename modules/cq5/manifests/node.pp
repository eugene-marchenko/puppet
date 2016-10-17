# Define: cq5::node
#
# This module manages a cq5 node
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::          This manages whether the cq5 node is installed or not.
#                       Valid values are true and false. Defaults to true.
#
# $enable::             Whether to enable the service or not
#
# $path::               The path to the cq5 directory
#
# $mount::              The mountpoint that cq5 resides on, the init script
#                       checks that the mount point exists.
#
# $role::               The context/role that the cq5 server will run as. Valid
#                       values are publish/author
#
# $env::                The environment for this server, e.g prod, uat, qa, dev
#
# $verbose_gc::         Whether to enable GC info in the log.
#
# $printgcdetails::     Whether to print additional GC details in the log.
#
# $printgctimestamps::  Whether to print timestamps of GC times in the log.
#
# $gc_algorithm::       The Garbage Collection algo to use. Default is
#                       Concurrent Mark Sweep.
#
# $permgen::            The permgen space in MB. Defaults to 256.
#
# $javaopts::           Additional JVM options to pass to the JVM.
#
# $heap_min::           The minimum heap in megabytes. Defaults to 128.
#
# $heap_max::           The maximum heap in megabytes. Defaults to 768.
#
# $max_files::          The maximum number of file handles allowed to the jvm.
#
# $interface::          The default is to listen on all interfaces.
#
# $javahome::           Specify an alternate javahome from $JAVA_HOME.
#
# == Requires:
#
# stdlib, cq5::params
#
# == Sample Usage:
#
# Install an author
# cq5::node { 'author' :
#   port  => '8080',
#   path  => '/opt/cq5/author',
#   mount => '/opt/cq5',
#   env   => 'prod',
#   role  => 'author',
# }
#
# Install an author and publisher on same box
# cq5::node { 'author' :
#   port  => '4502',
#   path  => '/opt/cq5/author',
#   mount => '/opt/cq5/author',
#   env   => 'prod',
#   role  => 'author',
# }

define cq5::node(
  $port,
  $path,
  $role,
  $env,
  $cq5_env,
  $mount              = undef,
  $installed          = true,
  $enable             = true,
  $verbose_gc         = true,
  $printgcdetails     = true,
  $printgctimestamps  = true,
  $gc_algorithm       = 'UseConcMarkSweepGC',
  $heap_min           = undef,
  $heap_max           = 768,
  $permgen            = 256,
  $javaopts           = undef,
  $max_files          = 65535,
  $interface          = undef,
  $javahome           = undef,
) {

  include stdlib
  include cq5::params

  validate_bool($installed,
                $enable,$verbose_gc,$printgcdetails,$printgctimestamps)

  if ! ($role in [ 'publish', 'author' ]) {
    fail('role parameter invalid, valid values are [ publish, author ]')
  }

  $gc_algorithm_javaopts = "-XX:+${gc_algorithm}"

  if $printgcdetails {
    $printgcdetails_javaopts = '-XX:+PrintGCDetails'
  } else {
    $printgcdetails_javaopts = ''
  }

  if $printgctimestamps {
    $printgctimestamps_javaopts = '-XX:+PrintGCTimeStamps'
  } else {
    $printgctimestamps_javaopts = ''
  }

  if $javaopts {
    $javaopts_real = "${javaopts} ${gc_algorithm_javaopts} \
${printgcdetails_javaopts} ${printgctimestamps_javaopts} \
-Dsling.run.modes=${role},${cq5_env}"
  } else {
    $javaopts_real = "${gc_algorithm_javaopts} ${printgcdetails_javaopts} \
${printgctimestamps_javaopts} \
-Dsling.run.modes=${role},${cq5_env}"
  }

  $service_ensure = $enable ? {
    true    => 'running',
    default => 'stopped',
  }

  case $installed {
    true: {
      file { "${path}/crx-quickstart/server/serverctl" :
        ensure  => 'present',
        path    => "${path}/crx-quickstart/server/serverctl",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('cq5/serverctl.erb'),
      }

      file { "${path}/newrelic/newrelic.yml" :
        ensure  => 'present',
        path    => "${path}/newrelic/newrelic.yml",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('cq5/configs/newrelic.yml.erb'),
      }

      file { "${path}/newrelic" :
        ensure  => 'directory',
        path    => "${path}/newrelic",
        recurse => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }

      file { "/opt/cq5/${name}/crx-quickstart/repository/repository.xml" :
        ensure  => 'file',
        path    => "/opt/cq5/${name}/crx-quickstart/repository/repository.xml",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template("cq5/configs/${name}_repository.xml.erb"),
      }

      file { "/opt/cq5/${name}/crx-quickstart/repository/workspaces/crx.default/workspace.xml" :
        ensure  => 'file',
        path    => "/opt/cq5/${name}/crx-quickstart/repository/workspaces/crx.default/workspace.xml",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template("cq5/configs/${name}_workspace.xml.erb"),
      }

      file { "/etc/init.d/cq5-${name}" :
        ensure  => 'present',
        path    => "/etc/init.d/cq5-${name}",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('cq5/init.erb'),
      }

      service { "cq5-${name}" :
        ensure     => $service_ensure,
        enable     => $enable,
        hasrestart => true,
      }

      File["${path}/crx-quickstart/server/serverctl"]
      ->  File["/etc/init.d/cq5-${name}"]
      ->  Service["cq5-${name}"]

      motd::register { "Cq5::Node::${name}" : }

    }
    false: {
      file { "${path}/crx-quickstart/server/serverctl" :
        ensure  => 'absent',
        path    => "${path}/crx-quickstart/server/serverctl",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('cq5/serverctl.erb'),
      }

      file { "${path}/newrelic/newrelic.yml" :
        ensure  => 'absent',
        path    => "${path}/newrelic/newrelic.yml",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('cq5/configs/newrelic.yml.erb'),
      }

      file { "${path}/newrelic" :
        ensure  => 'absent',
        path    => "${path}/newrelic",
      }

      file { "/opt/cq5/${name}/crx-quickstart/repository/repository.xml" :
        ensure  => 'absent',
        path    => "/opt/cq5/${name}/crx-quickstart/repository/repository.xml",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template("cq5/configs/${name}_repository.xml.erb"),
      }

      file { "/etc/init.d/cq5-${name}" :
        ensure  => 'absent',
        path    => "/etc/init.d/cq5-${name}",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('cq5/init.erb'),
      }

      File["${path}/crx-quickstart/server/serverctl"]
      ->  File["/etc/init.d/cq5-${name}"]
    }
    # Do Nothing.
    default: {}
  }
}
