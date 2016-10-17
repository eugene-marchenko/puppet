define rsyslog::config::property(
  $property,
  $comparison,
  $value,
  $destination,
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
      'precise' => template('rsyslog/Ubuntu/precise/rsyslog.d/custom_property.erb'),
      default   => template('rsyslog/Ubuntu/rsyslog.d/custom_property.erb'),
    },
  }

  if defined(Class[rsyslog::service]) {
    File["/etc/rsyslog.d/${name}.conf"] ~> Class[rsyslog::service]
  }
}
