# define build::package
node 'build-package-default' {
  include build::params
  build::package { 'build-packages':
    packages => $build::params::build_base_packages,
    defaults => $build::params::build_base_package_defaults,
  }
}

node 'build-package-no-params' {
  build::package { 'build-packages': }
}

# define build::config
node 'build-config-default' {
  include build::params
  build::config { 'build-configs' :
    configs => $build::params::build_devtools_configs,
  }
}

node 'build-config-no-params' {
  build::config { 'build-configs' : }
}

# class build

node 'class-build-default' {
  include build
}

node 'class-build-uninstalled' {
  class { 'build' : installed => false }
}

node 'class-build-installed-invalid' {
  class { 'build' : installed => yes }
}

# class build::devtools
node 'class-build-devtools-default' {
  include build::devtools
}

node 'class-build-devtools-uninstalled' {
  class { 'build::devtools' : installed => false }
}

node 'class-build-and-devtools-installed' {
  include build
  include build::devtools
}

# class build::devlibs
node 'class-build-devlibs-default' {
  include build::devlibs
  realize Package[libxml2-dev]
  Package <| title == 'libxslt1-dev' |> {
    ensure    => '1.1.1',
    provider  => 'apt',
  }
}
