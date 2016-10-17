# define git::package
node 'git-package-default' {
  include git::params
  git::package { 'git-packages':
    packages => $git::params::git_packages,
    defaults => $git::params::git_package_defaults,
  }
}

node 'git-package-no-params' {
  git::package { 'git-packages': }
}

# class git

node 'class-git-default' {
  include git
}

node 'class-git-uninstalled' {
  class { 'git' : installed => false }
}

node 'class-git-installed-invalid' {
  class { 'git' : installed => yes }
}
