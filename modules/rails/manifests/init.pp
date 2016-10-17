import 'classes/*.pp'

class rails {

  package { 'rails':
    name   => $operatingsystem ? {
      default  => 'rails',
      },
    ensure => present,
  }
}

