# = Class: python::params
#
# This module manages default parameters. It does the heavy lifting
# to determine operating system specific parameters.
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class python::someclass( packages = $python::params::some_param
# ) inherits python::params {
# ...do something
# }
#
# class { 'python::params' : }
#
# include python::params
#
class python::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    case $::lsbdistcodename {
      default: {
        $python_packages = {
          'python-dev'        => {},
          'python3'           => {},
          'python-dnspython'  => {},
          'python-paramiko'   => {},
          'python-yaml'       => {},
          'python-jinja2'     => {},
          'python-crypto'     => {},
          'boto'              => {
            'ensure'    => 'present',
            'provider'  => 'pip',
          },
          'Cirrus'            => {
            'ensure'    => 'present',
            'provider'  => 'pip',
          },
        }
        $python_package_defaults = {
          'ensure'    => 'latest',
          'provider'  => 'apt',
          'tag'       => 'python-package',
        }
        $python_pip_packages = [
          'BeautifulSoup',
          'cartodb',
          'html2text',
          'jinja2',
          'jenkinsapi',
          'jprops',
          'lxml',
          'mechanize',
          'nose',
          'oauth2',
          'pycurl',
          'pysolr',
          'pyyaml',
          'requests',
          'pyopenssl',
          'ndg-httpsclient',
          'pyasn1',
          'simplejson',
          'python-varnish',
          'tweepy',
          'urllib3',
          'slacker',
        ]
      }
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
