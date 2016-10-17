# = Define: sasl::user
#
# This manages mail alias configurations
#
# == Parameters:
#
# === Required:
#
# $password::   The plain text password for the user.
#
# === Optional:
#
# $ensure::     This parameter defines whether the user should be present or
#               absent. The default is true.
#
# $dbfile::     This parameter defines the path to the sasl database file.
#               Defaults to /etc/sasldb2.
#
# $mx_domain::  This parameter defines an optional domain for the user. Defaults
#               to undef.
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
# sasl::user { 'root' : password => 'sUp3rs3cur3' }
# sasl::user { 'relay' :
#   password  => 'kn0ckkn0ck',
#   dbfile    => '/var/spool/postfix/etc/sasldb2',
#   mx_domain => 'relay.example.com',
# }
#
define sasl::user(
  $password,
  $ensure     = true,
  $dbfile     = '/etc/sasldb2',
  $mx_domain  = undef,
) {

  include stdlib

  validate_bool($ensure)

  if $::postfix_chroot {
    $dbfile_real = "${::postfix_chroot}${dbfile}"
  } else {
    $dbfile_real = $dbfile
  }

  case $ensure {
    true: {
      if $mx_domain {
        $command = "echo ${password} | saslpasswd2 -p -f ${dbfile_real} -u ${mx_domain} ${name}"
        $condition = "sasldblistusers2 -f ${dbfile_real} | grep -q ${name}@${mx_domain}"
      } else {
        $command = "echo ${password} | saslpasswd2 -p -f ${dbfile_real} ${name}"
        $condition = "sasldblistusers2 -f ${dbfile_real} | grep -q ${name}"
      }

      exec { "sasl-manage-${name}" :
        command => $command,
        unless  => $condition,
      }
    }
    false: {
      if $mx_domain {
        $command = "saslpasswd2 -d -f ${dbfile_real} -u ${mx_domain} ${name}"
        $condition = "sasldblistusers2 -f ${dbfile_real} | grep -q ${name}@${mx_domain}"
      } else {
        $command = "saslpasswd2 -d -f ${dbfile_real} ${name}"
        $condition = "sasldblistusers2 -f ${dbfile_real} | grep -q ${name}"
      }

      exec { "sasl-manage-${name}" :
        command => $command,
        onlyif  => $condition,
      }
    }
    # Do Nothing.
    default: {}
  }
}
