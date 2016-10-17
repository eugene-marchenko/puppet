# = Define: postfix::mailalias
#
# This manages mail alias configurations
#
# == Parameters:
#
# === Required:
#
# $recipient::  This parameter expects the email address or user the alias
#               should forward to, e.g. recipient => 'foo@bar.com'
#
# === Optional:
#
# $ensure::     This parameter defines whether the alias should be present or
#               absent. The default is true.
#
# == Actions:
#
# Ensures the mail aliases are present or not, executes newaliases after
# the alias is created
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# postfix::mailalias { 'root' : recipient => 'foo@bar.com' }
#
define postfix::mailalias(
  $recipient,
  $ensure = true,
) {

  include stdlib

  validate_bool($ensure)

  case $ensure {
    true: {
      $ensure_real = present
    }
    false: {
      $ensure_real = absent
    }
    # Do Nothing.
    default: {}
  }

  mailalias { $name :
    ensure    => $ensure_real,
    recipient => $recipient,
    notify    => Exec["newaliases-${name}"],
  }

  exec { "newaliases-${name}" :
    refreshonly => true,
    command     => 'newaliases',
  }

}
