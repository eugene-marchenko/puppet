define rsyslog::config::file_monitor(
  $input_file_name,
  $input_file_tag,
  $input_file_state_file,
  $comment = undef,
  $discard = true,
) {

  include stdlib

  validate_bool($discard)

  file { "/etc/rsyslog.d/${name}.conf" :
    ensure  => 'present',
    path    => "/etc/rsyslog.d/${name}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $::lsbdistcodename ? {
      'precise' => template('rsyslog/Ubuntu/precise/rsyslog.d/custom_file_monitor.erb'),
      default   => template('rsyslog/Ubuntu/rsyslog.d/custom_file_monitor.erb'),
    },
  }

  if defined(Class[rsyslog::service]) {
    File["/etc/rsyslog.d/${name}.conf"] ~> Class[rsyslog::service]
  }
}
