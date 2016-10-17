# Class: newrelic::params
#
#
class newrelic::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports newrelic version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Resource defaults
    $newrelic_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'newrelic-package',
    }

    case $::roles {
      /author|dispatcher|qaproxy/: {
        $newrelic_services = {
          'newrelic-plugin-agent'     => {
            'ensure'  => 'running',
            'enable'  => true,
          },
          'newrelic-sysmond'  => {
            'ensure'  => 'running',
            'enable'  => true,
          },
        }
      } default: {
        $newrelic_services = {
          'newrelic-plugin-agent'     => {
            'ensure'  => 'stopped',
            'enable'  => false,
          },
          'newrelic-sysmond'  => {
            'ensure'  => 'running',
            'enable'  => true,
          },
        }
      }
    }

    $newrelic_packages = {
      'newrelic-plugin-agent' => {
        'ensure'    => 'present',
        'provider'  => 'pip',
      },
      'python-openssl'    => {
        'ensure'    => 'purged',
        'provider'  => 'apt',
      },
      'newrelic-sysmond'  => {
        'ensure'  => 'present',
        'provider'  => 'apt',
      },
    }

    $newrelic_configs = {
      '/etc/newrelic/newrelic-plugin-agent.cfg'          => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('newrelic/configs/newrelic-plugin-agent.cfg.erb')
      },
      '/etc/newrelic' => {
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      },
      '/var/log/newrelic' => {
        'ensure' => 'directory',
        'owner'  => 'newrelic',
        'group'  => 'newrelic',
        'mode'   => '0755',
        'recurse' => true,
      },
      '/var/run/newrelic/'  => {
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'recurse' => false,
      },
      '/var/run/newrelic/newrelic-plugin-agent.pid' => {
        'owner'   => 'newrelic',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/newrelic/nrsysmond.cfg' => {
        'ensure'  => 'present',
        'owner'   => 'newrelic',
        'group'   => 'newrelic',
        'mode'    => '0640',
        'content' => template('newrelic/configs/nrsysmond.cfg.erb')
      },
      '/etc/init.d/newrelic-plugin-agent'        => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'content' => template('newrelic/init.d/newrelic-plugin-agent.erb')
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
