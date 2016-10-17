# define jmeter::package
node 'jmeter-package-default' {
  include jmeter::params
  jmeter::package { 'jmeter-packages':
    packages => $jmeter::params::jmeter_packages,
    defaults => $jmeter::params::jmeter_package_defaults,
  }
}

node 'jmeter-package-no-params' {
  jmeter::package { 'jmeter-packages': }
}

# class jmeter

node 'class-jmeter-default' {
  include jmeter
}

node 'class-jmeter-uninstalled' {
  class { 'jmeter' : installed => false }
}

node 'class-jmeter-installed-invalid' {
  class { 'jmeter' : installed => yes }
}
