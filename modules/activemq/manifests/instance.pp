# Define: activemq::instance
#
# This define manages activemq instances.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::        This manages whether the activemq instance is installed or
#                     not. Valid values are true and false. Defaults to true.
#
# $enabled::          Whether the instance is enabled or not.
#
# $base::             The base path to the activemq data directory.
#
# $java_home::        The java home path.
#
# $min_heap::         The min heap to set for the jvm.
#
# $max_heap::         The max heap to set for the jvm.
#
# $jvm_opts::         The jvm opts to use.
#
# $args::             The activemq args to use.
#
# $config_source::    The activemq.xml config from a source location.
#
# $config_template::  The activemq.xml config from a template.
#
# $config_content::   The activemq.xml config from a string.
#
# $log4j_source::     The log4j.properties config from a source location.
#
# $log4j_template::   The log4j.properties config from a template.
#
# $log4j_content::    The log4j.properties config from a string.
#
# $options_source::   The options file config from a source location.
#
# $options_template:: The options file config from a template.
#
# $options_content::  The options file config from a string.
#
# == Requires:
#
# stdlib, activemq::params
#
# == Sample Usage:
#
# activemq::instance { 'foo' : }
#
# activemq::instance { 'foo' : enable => false }
#
# activemq::instance { 'foo' :
#   enable        => false
#   config_source => 'puppet:///modules/activemq/path/to/activemq.xml',
# }
#
define activemq::instance(
  $installed        = true,
  $enabled          = true,
  $base             = undef,
  $java_home        = undef,
  $min_heap         = '512',
  $max_heap         = '512',
  $jvm_opts         = undef,
  $args             = undef,
  $config_source    = undef,
  $config_template  = undef,
  $config_content   = undef,
  $log4j_source     = undef,
  $log4j_template   = undef,
  $log4j_content    = undef,
  $options_source   = undef,
  $options_template = undef,
  $options_content  = undef,
) {

  include stdlib
  include activemq
  include activemq::params

  $instance_dir = $activemq::params::instance_dir
  $enable_dir   = $activemq::params::enable_dir

  # Create base dir (data dir) if it does not already exist
  if $base {
    exec { "activemq::instance::${name}(mkdir -p ${base})" :
      command => "mkdir -p ${base}",
      unless  => "test -d ${base}",
      before  => File["${instance_dir}/${name}"],
    }
  }

  # Find out what type of content to provide to activemq.xml resource
  if $config_content {
    $config_is = 'content'
    $config = $config_content
  } elsif $config_source {
    $config_is = 'source'
    $config = $config_source
  } elsif $config_template {
    $config_is = 'content'
    $config = template($config_template)
  } else {
    $config_is = 'content'
    $config = template($activemq::params::config_file)
  }

  # Find out what type of content to provide to log4j.properties resource
  if $log4j_content {
    $log4j_is = 'content'
    $log4j = $log4j_content
  } elsif $log4j_source {
    $log4j_is = 'source'
    $log4j = $log4j_source
  } elsif $log4j_template {
    $log4j_is = 'content'
    $log4j = template($log4j_template)
  } else {
    $log4j_is = 'content'
    $log4j = template($activemq::params::log4j_properties)
  }

  # Find out what type of content to provide to options resource
  if $options_content {
    $options_is = 'content'
    $options = $options_content
  } elsif $options_source {
    $options_is = 'source'
    $options = $options_source
  } elsif $options_template {
    $options_is = 'content'
    $options  = template($options_template)
  } else {
    $options_is = 'content'
    $options = template($activemq::params::options_file)
  }

  # Set resource defaults
  # Would prefer to use the Resource default syntax, but using collections
  # below to override these defaults doesn't work per
  # http://projects.puppetlabs.com/issues/5761
  # TODO: Revisit in puppet 3.0
  #File {
  #  ensure  => 'present',
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  tag     => "activemq-instance-${name}-file",
  #  notify  => Class[activemq::services],
  #}

  # Set our resource defaults
  $file_defaults = {
    'ensure'  => 'present',
    'owner'   => 'root',
    'group'   => 'root',
    'mode'    => '0644',
    'tag'     => "activemq-instance-${name}-file",
    'notify'  => Class[activemq::services],
  }

  # Construct a files hash for use with create_resources()
  $files = {}

  # Add instance directory
  $files["${instance_dir}/${name}"] = {
    'ensure'  => 'directory',
    'mode'    => '0755'
  }

  # Add activemq.xml file
  if $config_is == 'source' {
    $files["${instance_dir}/${name}/activemq.xml"] = { 'source'  => $config }
  } else {
    $files["${instance_dir}/${name}/activemq.xml"] = { 'content' => $config }
  }

  # Add log4j properties file
  if $log4j_is == 'source' {
    $files["${instance_dir}/${name}/log4j.properties"] = { 'source'  => $log4j }
  } else {
    $files["${instance_dir}/${name}/log4j.properties"] = { 'content' => $log4j }
  }

  # Add options file
  if $options_is == 'source' {
    $files["${instance_dir}/${name}/options"] = { 'source'  => $options }
  } else {
    $files["${instance_dir}/${name}/options"] = { 'content' => $options }
  }

  # Add enable symlink
  $files["${enable_dir}/${name}"] = {
    'ensure'  => 'link',
    'target'  => "${instance_dir}/${name}",
  }

  # Now create those resources!
  create_resources(file,$files,$file_defaults)

  case $installed {
    true: {
      case $enabled {
        true: {}
        false: {
          # We can override an already created resource with a collection
          File <| title == "${enable_dir}/${name}" |> {
            ensure  => 'absent',
          }
        }
        default: {
          fail("Boolean expected for \$enabled param: got => ${enabled}")
        }
      }
    }
    false: {
      # Since installed is false, override resources via collection
      File <| tag == "activemq-instance-${name}-file" |> {
        ensure  => 'absent',
      }
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
