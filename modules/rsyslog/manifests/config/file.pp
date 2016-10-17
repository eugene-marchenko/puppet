define rsyslog::config::file(
  $content,
) {

  file { "/etc/rsyslog.d/${name}.conf" :
    ensure  => present,
    path    => "/etc/rsyslog.d/${name}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content,
  }

  if defined(Class[rsyslog::service]) {
    File["/etc/rsyslog.d/${name}.conf"] ~> Class[rsyslog::service]
  }
}
