class roles::packages() {
  include roles::base
  package { 'unzip':   ensure => 'installed' }
  package { 'htop':   ensure => 'installed' }
  package { 'mc':   ensure => 'installed' }
  package { 'python-pip':   ensure => 'installed' }
}
