class motd(
  $motd_file = $motd::params::motd_local_file
) inherits motd::params {

  include stdlib
  include concat::setup

  concat { $motd_file:
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  concat::fragment { 'motd_header' :
    target  => $motd_file,
    content => "\nPuppet modules on this server:\n\n",
    order   => '01',
  }

  concat::fragment { 'motd_end' :
    target  => $motd_file,
    content => "\n------------------------------\n\n",
    order   => '50',
  }

}
