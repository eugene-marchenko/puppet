# class skeleton_pkg_only::packages
node 'class-skeleton_pkg_only-packages-default' {
  include skeleton_pkg_only::packages
}

node 'class-skeleton_pkg_only-packages-uninstalled' {
  class { 'skeleton_pkg_only::packages': installed => false }
}

node 'class-skeleton_pkg_only-packages-diff-version' {
  class { 'skeleton_pkg_only::packages': version => 'foo-version' }
}

node 'class-skeleton_pkg_only-packages-diff-uninstall-overrides' {
  class { 'skeleton_pkg_only::packages':
    version   => 'foo-version',
    installed => false
  }
}

# class skeleton_pkg_only
node 'class-skeleton_pkg_only-default' {
  include skeleton_pkg_only
}

node 'class-skeleton_pkg_only-uninstalled' {
  class { 'skeleton_pkg_only' : installed => false }
}
