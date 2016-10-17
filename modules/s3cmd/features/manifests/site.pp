# define s3cmd::package
node 's3cmd-package-default' {
  include s3cmd::params
  s3cmd::package { 's3cmd-packages':
    packages => $s3cmd::params::s3cmd_packages,
    defaults => $s3cmd::params::s3cmd_package_defaults,
  }
}

node 's3cmd-package-no-params' {
  s3cmd::package { 's3cmd-packages': }
}

# class s3cmd

node 'class-s3cmd-default' {
  include s3cmd
}

node 'class-s3cmd-uninstalled' {
  class { 's3cmd' : installed => false }
}

node 'class-s3cmd-installed-invalid' {
  class { 's3cmd' : installed => yes }
}
