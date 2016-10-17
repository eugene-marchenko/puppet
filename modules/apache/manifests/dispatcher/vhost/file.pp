# Define: apache::dispatcher::vhost::file
#
# This module installs dispatcher vhost specific files
#
# == Parameters:
#
# == Required:
#
# $servername::   The servername of the vhost. Needed to create the directory
#                 to add the file in if no path is specified, 
#
# == Optional:
#
# $ensure::       Whether this file is present or not. Defaults to present.
#
# $path::         The optional path to this file.
#
# $template::     The template to use. Highest priority.
#
# $content::      The content to use, next highest priority.
#
# $source::       The puppet filebucket source for the file. Lowest priority.
#
# $apache_name::  The apache name, used in creating the directory to store the
#                 file.
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# apache::dispatcher::vhost::file { 'www.example.com' :
#   template  => 'apache/path/to/file',
# }
#
define apache::dispatcher::vhost::file(
  $servername,
  $ensure = 'present',
  $path = '',
  $template = '',
  $content = '',
  $source = '',
  $apache_name = 'apache2',
) {

  include stdlib
  include apache::dispatcher::params

  $srvname = $servername
  $docroot = "/etc/${apache_name}/${servername}"

  case $template {
    '': {
      case $content {
        '': {
          case $source {
            '': { fail('No template, content or source specified') }
            default: { File{ source => $source} }
          }
        }
        default: { File{ content => $content} }
      }
    }
    default: { File{ content => template($template)} }
  }

  case $path {
    '': {
      $path_real = "/etc/${apache_name}/${servername}/${name}"
    }
    default: {
      $path_real = $path
    }
  }

  case $ensure {
    'present', 'absent', 'file': { $ensure_real = $ensure }
    default: { fail('Invalid ensure. Valid ensures are present, absent or file') }
  }

  file { $path_real :
    ensure => $ensure_real,
    path   => $path_real,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
