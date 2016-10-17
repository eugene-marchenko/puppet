# = Define: ssh::config::file
#
# This define manages ssh configuration files.
#
# == Parameters:
#
# $config::       A hash containing the following:
#                 $ensure
#                 $path
#                 $content
#                 $source
#                 $target
#                 $mode
#                 $owner
#                 $group
#                 $require
#                 $before
#                 $notify
#
# === Optional:
#
# == Actions:
#
# Ensures the ssh configuration file(s) is/are either present or not.
#
# == Requires:
#
# ssh::package
#
# == Sample Usage:
#
# ssh::config::file { '/tmp/test' :
#   config => { '/tmp/test' => {
#                 ensure  => 'present',
#                 path    => '/tmp/test',
#                 content => undef,
#                 source  => undef,
#                 target  => undef,
#                 mode    => "0644",
#                 owner   => "nobody",
#                 group   => "nobody",
#                 require => undef,
#                 before  => undef,
#                 notify  => undef,
#                 },
#             }
# }
#
# With defaults,
#
# ssh::config::file { '/tmp/test' :
#   config => { '/tmp/test' => {
#                 ensure  => 'present',
#                 },
#             }
# }
#
define ssh::config::file(
  $config,
  $debug = false,
) {

  include stdlib
  include ssh::params

  validate_bool($debug)
  validate_hash($config)

  $my_hash = $config[$name]

  validate_hash($my_hash)

  if has_key($my_hash, 'ensure') {
    if $my_hash[ensure] in [ 'present', 'absent', 'link',
                            'directory', 'file' ] {
      $ensure_real = $my_hash[ensure]
    } else {
      fail('ensure must be present, absent, link, directory, or file')
    }
  } else {
    $ensure_real = 'present'
  }

  if has_key($my_hash, 'path') {
    $path_real = $my_hash[path]
  } else {
    $path_real = $name
  }

  if has_key($my_hash, 'content') {
    $content_real = $my_hash[content]
  } else {
    $content_real = undef
  }

  if has_key($my_hash, 'source') {
    $source_real = $my_hash[source]
  } else {
    $source_real = undef
  }

  if has_key($my_hash, 'target') {
    $target_real = $my_hash[target]
  } else {
    $target_real = undef
  }

  if has_key($my_hash, 'mode') {
    $mode_real = $my_hash[mode]
  } else {
    $mode_real = '0600'
  }

  if has_key($my_hash, 'owner') {
    $owner_real = $my_hash[owner]
  } else {
    $owner_real = 'root'
  }

  if has_key($my_hash, 'group') {
    $group_real = $my_hash[group]
  } else {
    $group_real = 'root'
  }

  if has_key($my_hash, 'require') {
    $require_real = $my_hash[require]
  } else {
    $require_real = undef
  }

  if has_key($my_hash, 'before') {
    $before_real = $my_hash[before]
  } else {
    $before_real = undef
  }

  if has_key($my_hash, 'notify') {
    $notify_real = $my_hash[notify]
  } else {
    $notify_real = undef
  }

  if ($debug) {
    #To Puppetmaster
    notice("ensure  => ${ensure_real}")
    notice("path    => ${path_real}")
    notice("content => ${content_real}")
    notice("source  => ${source_real}")
    notice("target  => ${target_real}")
    notice("mode    => ${mode_real}")
    notice("owner   => ${owner_real}")
    notice("group   => ${group_real}")
    notice("require => ${require_real}")
    notice("before  => ${before_real}")
    notice("notify  => ${notify_real}")
    #To Puppetagent
    notify{"ensure  => ${ensure_real}": }
    notify{"path    => ${path_real}": }
    notify{"source  => ${source_real}": }
    notify{"target  => ${target_real}": }
    notify{"mode    => ${mode_real}": }
    notify{"owner   => ${owner_real}": }
    notify{"group   => ${group_real}": }
    notify{"require => ${require_real}": }
    notify{"before  => ${before_real}": }
    notify{"notify  => ${notify_real}": }
  }

  file { $name :
    ensure  => $ensure_real,
    path    => $path_real,
    content => $content_real,
    source  => $source_real,
    target  => $target_real,
    mode    => $mode_real,
    owner   => $owner_real,
    group   => $group_real,
    require => $require_real,
    before  => $before_real,
    notify  => $notify_real,
  }
}
