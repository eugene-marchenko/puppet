# define lvm2::package
node 'lvm2-package-default' {
  include lvm2::params
  lvm2::package { 'lvm2-packages':
    packages => $lvm2::params::lvm2_packages,
    defaults => $lvm2::params::lvm2_package_defaults,
  }
}

node 'lvm2-package-no-params' {
  lvm2::package { 'lvm2-packages': }
}

# class lvm2

node 'class-lvm2-default' {
  include lvm2
}

node 'class-lvm2-uninstalled' {
  class { 'lvm2' : installed => false }
}

node 'class-lvm2-installed-invalid' {
  class { 'lvm2' : installed => yes }
}
