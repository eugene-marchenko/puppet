node 'default' {
  class { 'apt': disable_keys => true }
  apt::force { 'testing':}
  apt::force { 'withVersion': version => '12' }
  apt::force { 'withRelease': release => 'stable' }
  apt::force { 'withReleaseAndVersion': version => 'verSION!', release => 'stable' }
  class { 'apt::release': release_id => 'karmic' }
}

node 'source' {
  include apt
  apt::source { 'cucumber':}
}

node 'source-pin' {
  include apt
  apt::source { 'cucumber':
    release => 'cucumber',
    pin     => '100',
  }
}

node 'source-key' {
  include apt
  apt::source { 'cucumber':
    key => 'ABAD1DEA',
  }
}

node 'source-key-and-content' {
  include apt
  apt::source { 'cucumber':
    key         => 'ABAD1DEA',
    key_content => 'HEXHEXHEX',
  }
}

node 'pin' {
  apt::pin { 'pin-also-fail':
    fail => 'probably',
  }
}

node 'define-pin' {
  apt::pin { 'pin-default': }
  apt::pin { 'pin-with-params':
    packages => 'mysql',
    priority => '788',
  }
}

node 'define-pin-fail' {

  apt::pin { 'pin-fail':
    fail => 'probably',
  }
}

node 'define-ppa' {
  include apt
  apt::ppa { 'default': }
  apt::ppa { 'other': }
}

node 'define-ppa-fail' {
  apt::ppa { 'ppa-fail':
    fail => 'probably',
  }
}

node 'define-ppa-also-fail' {
  include apt
  apt::ppa { 'ppa-also-fail':
    fail => 'probably',
  }
}

node 'define-force' {
  apt::force { 'force-default': }
  apt::force { 'force-params':
    release => 'stable',
    version => '123',
  }
}

node 'define-force-fail' {
  apt::force { 'force-fail':
    fail => 'probably',
  }
}

node 'class-release' {
  class { 'apt::release':
    release_id => 'lenny',
  }
}

node 'class-release-duplicate' {
  class { 'apt::release':
    release_id => 'lenny',
  }

  class { 'apt::release':
    release_id => 'stable',
  }
}

node 'class-params' {
  class { 'apt::params': }
}

node 'class-params-param' {
  class { 'apt::params':
    fail => 'YES!',
  }
}

node 'class-params-duplicate' {
  class { 'apt::params': }
  class { 'apt::params': }
}

node 'class-init-default' {
  class { 'apt': }
}

node 'class-init-params' {
  class { 'apt':
    disable_keys      => true,
    always_apt_update => true,
  }
}

node 'class-init-duplicate' {
  class { 'apt': }
  class { 'apt': }
}

node 'class-init-extra-param' {
  class { 'apt':
    fail => 'YES!',
  }
}

node 'class-apt-debian-testing' {
  class { 'apt::debian::testing': }
}
node 'class-apt-debian-testing-params' {
  class { 'apt::debian::testing':
    fail => 'it should',
  }
}

node 'class-apt-debian-testing-duplicate' {
  class { 'apt::debian::testing': }
  class { 'apt::debian::testing': }
}

node 'class-apt-debian-unstable' {
  class { 'apt::debian::unstable': }
}

node 'class-apt-debian-unstable-params' {
  class { 'apt::debian::unstable':
    fail => 'it should',
  }
}

node 'class-apt-debian-unstable-duplicate' {
  class { 'apt::debian::unstable': }
  class { 'apt::debian::unstable': }
}
