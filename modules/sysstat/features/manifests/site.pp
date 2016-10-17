# class packages
node 'class-sysstat-packages-default' {
  include sysstat::packages
}

node 'class-sysstat-packages-custom-packages' {
  class { 'sysstat::packages' : packages => [ 'foo', 'bar' ] }
}

node 'class-sysstat-packages-hash' {
  class { 'sysstat::packages' :
    packages => {
      'packages' => [ 'sysstat' ],
    }
  }
}

node 'class-sysstat-packages-string' {
  class { 'sysstat::packages' : packages => 'sysstat-custom' }
}

# class sysstat

node 'class-sysstat' {
  include sysstat
}

node 'class-sysstat-uninstalled' {
  class { 'sysstat' : installed => false }
}

node 'class-sysstat-installed-invalid' {
  class { 'sysstat' : installed => yes }
}

node 'class-sysstat-custom-packages' {
  class { 'sysstat' : packages => [ 'foo', 'bar' ] }
}

node 'class-sysstat-custom-hiera-packages' {
  class { 'sysstat' : packages => hiera('sysstat_packages') }
}

node 'class-sysstat-custom-key' {
  class { 'sysstat' :
    packages     => hiera('sysstat_package_hash'),
    packages_key => 'new_packages',
  }
}
