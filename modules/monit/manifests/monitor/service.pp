# Define: monit::monitor::service
#
define monit::monitor::service(
  $ensure      = true,
  $initscript  = "/etc/init.d/${name}",
  $pidfile     = "/var/run/${name}/${name}.pid",
) {

  include monit::params
  include stdlib
  include monit

  if $::monit_dot_dir {
    $monit_dot_dir = $::monit_dot_dir
  } else {
    $monit_dot_dir = $monit::params::monit_dot_dir
  }

  validate_bool($ensure)

  case $ensure {
    true: {
      $ensure_real = 'present'
    }
    false: {
      $ensure_real = 'absent'
    }
    default: {}
  }

  $config = {}
  $config["$monit_dot_dir/$name"] = {
    'ensure'  => $ensure_real,
    'owner'   => 'root',
    'group'   => 'root',
    'mode'    => '0644',
    'content' => $::lsbdistcodename ? {
      'precise' => template('monit/Ubuntu/precise/conf.d/service.erb'),
      default   => template('monit/Ubuntu/conf.d/service.erb'),
    },
  }

  monit::config { $name: configs => $config }

  Monit::Config[$name] ~> Class[monit::service]
}
