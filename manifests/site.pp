import 'nodes.pp'

node default {
  package { 'httpd':
    ensure => 'installed'
  }
}
