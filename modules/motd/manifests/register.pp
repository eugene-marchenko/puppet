define motd::register(
  $content  = '',
  $order    = '10',
) {

  include motd::params
  include motd

  $motd_file = $motd::params::motd_local_file

  if $content == '' {
    $body = $name
  } else {
    $body = $content
  }

  concat::fragment{ "motd_fragment_${name}" :
    target  => $motd_file,
    content => "    -- ${body}\n",
    order   => $order,
  }
}
